

---@param entity LuaEntity
function track_ghost(entity)
    if not entities.is_ghost(entity) then return end

    for _, cell in pairs(storage.logisticCells) do
        if cell.logisticCell.is_in_construction_range(entity.position) then
            game.print("Tracking ghost " .. entity.name)
            storage.trackers[cell] = entity
            return
        end
    end
end

-- TODO: this is a copy, requires rewrite.
---@param entity LuaEntity
function untrack_ghost(entity)
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
function track_ghost_tracker(entity)
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


-- TODO: this is a copy, requires rewrite.
---@param entity LuaEntity
function untrack_ghost_tracker(entity)
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
function track_logistic_cell(entity)
    local logisticCell = entity.logistic_cell
    if logisticCell == nil then return end
    local network = logisticCell.logistic_network
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

-- TODO: this is a copy, requires rewrite.
---@param entity LuaEntity
function untrack_logistic_cell(entity)
    local logisticCell = entity.logistic_cell
    if logisticCell == nil then return end
    local network = logisticCell.logistic_network
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


---@param network LuaLogisticNetwork
function get_network_tracked_entities(network)
    local entities = {}
    for _, logisticCell in pairs(storage.logisticNetworks[network]) do
        for _, entity in pairs(storage.logisticCells[logisticCell].entities) do
            table.insert(entities, entity)
        end
    end
    return table.unique(entities)
end

function get_all_tracked_entities()
    local entities = {}
    for _, data in pairs(storage.logisticCells) do
        for _, entity in pairs(data.entities) do
            table.insert(entities, entity)
        end
    end
    return table.unique(entities)
end
