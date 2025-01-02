require("__heroic_library__.utilities")
require("__heroic_library__.table")
require("__heroic_library__.entities")

local function get_all_tracked_entities()
    local entities = {}
    for _, data in pairs(storage.logisticCells) do
        for _, entity in pairs(data.entities) do
            table.insert(entities, entity)
        end
    end
    return table.unique(entities)
end

---@param network LuaLogisticNetwork
local function get_network_tracked_entities(network)
    local entities = {}
    for _, logisticCell in pairs(storage.logisticNetworks[network]) do
        for _, entity in pairs(storage.logisticCells[logisticCell].entities) do
            table.insert(entities, entity)
        end
    end
    return table.unique(entities)
end


---@param entity LuaEntity
local function track_ghost(entity)
    if not entities.is_ghost(entity) then return end

    for _, cell in pairs(storage.logisticCells) do
        if cell.logisticCell.is_in_construction_range(entity.position) then
            game.print("Tracking ghost " .. entity.name)
            storage.trackers[cell] = entity
            return
        end
    end
end

---@param entity LuaEntity
local function track_ghost_tracker(entity)
    if entity.type ~= "roboport" then
        return
    end

    for _, cell in pairs(storage.logisticCells) do
        if cell.logisticCell.is_in_logistic_range(entity.position) then
            game.print("Tracking ghost tracker " .. entity.name)
            storage.trackers[cell] = entity
            return
        end
    end
end

---@param entity LuaEntity
local function track_logistic_cell(entity)
    local logisticCell = entity.logistic_cell
    local network = logisticCell.logistic_network

    if logisticCell == nil then return end
    if network == nil then return end

    local radius = logisticCell.construction_radius
    local entities = entity.surface.find_entities_filtered{
        area = {
            {entity.position.x - radius, entity.position.y - radius},
            {entity.position.x + radius, entity.position.y + radius}
        },
        type = "entity-ghost"
    }

    if storage.logisticNetworks[network] == nil then
        storage.logisticNetworks[network] = {}
    end
    table.insert(storage.logisticNetworks[network], logisticCell)
    storage.logisticCells[entity] = {
        logisticCell = logisticCell,
        entities = entities
    }
    game.print("Logistics cell " .. entity.name)
end

---@param entity LuaEntity
local function on_built(entity)
    track_logistic_cell(entity)
    track_ghost_tracker(entity)
    track_ghost(entity)
end


local function on_destroyed(entity)
    if entity.name == "ghost-entity" then
        for _, cell in pairs(storage.logisticCells) do
            if cell.logisticCell.is_in_construction_range(entity.position) then
                storage.trackers[cell] = nil
                return
            end
        end
    end

    if entity.type == "roboport" then
        for _, cell in pairs(storage.logisticCells) do
            if cell.logisticCell.is_in_logistic_range(entity.position) then
                storage.trackers[cell] = nil
                return
            end
        end
    end

    local logisticCell = entity.logistic_cell
    if logisticCell == nil then return end
    local network = logisticCell.logistic_network
    if network == nil then return end

    table.remove(storage.logisticNetworks[network], logisticCell)
    storage.logisticCells[entity] = nil
end

script.on_init(function ()
    ---@type table<LuaEntity, {logisticCell: LuaLogisticCell, entities: LuaEntity[]}>
    storage.logisticCells = {}
    ---@type table<LuaLogisticNetwork, {logisticCells: LuaEntity[]}>
    storage.logisticNetworks = {}
    ---@type {logisticCells: LuaEntity[]}
    storage.trackers = {}

    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered{type = "roboport"}) do
            on_built(entity)
        end
    end
end)

script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.script_raised_built,
        defines.events.script_raised_revive,
    },
    ---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.script_raised_built | EventData.script_raised_revive
function (event)
    if event.entity then
        on_built(event.entity)
        return
    end
    if event.created_entity then
        on_built(event.created_entity)
        return
    end
end)


script.on_event(
    {
        defines.events.on_player_mined_entity,
        defines.events.on_robot_mined_entity,
        defines.events.on_entity_died,
        defines.events.script_raised_destroy,
    },
    ---@param event EventData.on_player_mined_entity | EventData.on_robot_mined_entity | EventData.on_entity_died | EventData.script_raised_destroy
    function (event)
        if not entities.is_valid(event.entity) then return end
        on_destroyed(event.entity)
    end
)
