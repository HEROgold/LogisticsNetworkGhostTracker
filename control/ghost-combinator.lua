

require("__heroic-library__.entities")
local Set = require("__heroic-library__.set")

-- storage.combinators: table<integer, LuaEntity> indexed by unit_number
-- Initialized in events.init

local function clear_combinator_signals(entity)
	if not entities.is_valid(entity) then return end
	local behavior = entity.get_or_create_control_behavior()
	if behavior == nil then return end
	local slots = entity.prototype and entity.prototype.item_slot_count or 15
	for i = 1, slots do
		behavior.set_signal(i, nil)
	end
end

local function set_non_interactable(entity)
	if not entities.is_valid(entity) then return end
	-- Prevent players from editing the constant combinator GUI; we'll drive it via script
	entity.operable = false
	entity.rotatable = false
end

local function bounding_box(center, radius)
	return {
		{center.x - radius, center.y - radius},
		{center.x + radius, center.y + radius}
	}
end

local function collect_network_ghost_item_counts(entity)
	---@type table<string, integer>
	local counts = {}
	if not entities.is_valid(entity) then return counts end

	local surface = entity.surface
	local network = surface.find_logistic_network_by_position(entity.position, entity.force)
	if not network then return counts end

	-- Deduplicate ghosts across overlapping cells by unit_number
	local seen = Set.new()

	for _, cell in pairs(network.cells or {}) do
		if cell.valid then
			local owner = cell.owner
			if owner and owner.valid then
				local area = bounding_box(owner.position, cell.construction_radius)
				local ghosts = surface.find_entities_filtered({ area = area, type = "entity-ghost", force = entity.force })
				for _, g in pairs(ghosts) do
					local id = g.unit_number or (g.ghost_name .. ":" .. g.position.x .. ":" .. g.position.y)
					if not seen:has(id) then
						seen:add(id)
						local proto = g.ghost_prototype
						if proto and proto.items_to_place_this then
							for _, stack in pairs(proto.items_to_place_this) do
								local name = stack.name
								local amount = stack.count or 1
								counts[name] = (counts[name] or 0) + amount
							end
						end
					end
				end
			end
		end
	end

	return counts
end

local function apply_counts_to_combinator(entity, counts)
	if not entities.is_valid(entity) then return end
	local behavior = entity.get_or_create_control_behavior()
	if behavior == nil then return end

	-- Sort keys for deterministic ordering
	local keys = {}
	for name, _ in pairs(counts) do table.insert(keys, name) end
	table.sort(keys)

	local slots = entity.prototype and entity.prototype.item_slot_count or 15
	local i = 1
	for _, name in ipairs(keys) do
		if i > slots then break end
		local count = counts[name]
		behavior.set_signal(i, { signal = { type = "item", name = name }, count = count })
		i = i + 1
	end
	-- Clear remaining slots
	for j = i, slots do
		behavior.set_signal(j, nil)
	end
end

function register_ghost_combinator(entity)
	if not entities.is_valid(entity) then return end
	if entity.name ~= GhostCombinator then return end
	storage.combinators = storage.combinators or {}
	storage.combinators[entity.unit_number] = entity
	set_non_interactable(entity)
	clear_combinator_signals(entity)
end

function unregister_ghost_combinator(entity)
	if not entity then return end
	if storage.combinators then
		storage.combinators[entity.unit_number or 0] = nil
	end
end

function update_ghost_combinator(entity)
	if not entities.is_valid(entity) then return end
	if entity.name ~= GhostCombinator then return end
	local counts = collect_network_ghost_item_counts(entity)
	apply_counts_to_combinator(entity, counts)
end

function update_all_ghost_combinators()
	if not storage.combinators then return end
	for _, entity in pairs(storage.combinators) do
		update_ghost_combinator(entity)
	end
end

-- Periodic refresh to keep outputs in sync with changing ghosts
script.on_nth_tick(60, function()
	update_all_ghost_combinators()
end)
