require("__heroic-library__.vars.words")
require("__heroic-library__.vars.strings")
require("__heroic-library__.entities")
require("__heroic-library__.table")


function clean_cells()
    for _, cell in pairs(storage.logisticCells) do
        if not cell.logisticCell.valid then
            storage.trackers[cell] = nil
        end
    end
end

---@param entity LuaEntity
function track_ghost(entity)
    if not entities.is_ghost(entity) then return end

    for _, cell in pairs(storage.logisticCells) do
        if not cell.logisticCell.valid then goto continue end
        if cell.logisticCell.is_in_construction_range(entity.position) then
            game.print("Tracking ghost " .. entity.name)
            storage.trackers[cell] = entity
        end
        ::continue::
    end
end

---@param entity LuaEntity
function untrack_ghost(entity)
    if not entities.is_ghost(entity) then return end
    for _, cell in pairs(storage.logisticCells) do
        if not cell.logisticCell.valid then goto continue end
        if cell.logisticCell.is_in_construction_range(entity.position) then
            storage.trackers[cell] = nil
            game.print("no-Tracking ghost " .. entity.name)
        end
        ::continue::
    end
end

---@param entity LuaEntity
function track_ghost_tracker(entity)
    if entity.type ~= Roboport then return end

    for _, cell in pairs(storage.logisticCells) do
        if not cell.logisticCell.valid then goto continue end
        if cell.logisticCell.is_in_logistic_range(entity.position) then
            game.print("Tracking ghost tracker " .. entity.name)
            storage.trackers[cell] = entity
        end
        ::continue::
    end
end


---@param entity LuaEntity
function untrack_ghost_tracker(entity)
    if entity.type ~= Roboport then return end
    for _, cell in pairs(storage.logisticCells) do
        if not cell.logisticCell.valid then goto continue end
        if cell.logisticCell.is_in_logistic_range(entity.position) then
            game.print("no-Tracking ghost tracker " .. entity.name)
            storage.trackers[cell] = nil
        end
        ::continue::
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

---@param entity LuaEntity
function untrack_logistic_cell(entity)
    local logisticCell = entity.logistic_cell
    if logisticCell == nil then return end
    local network = logisticCell.logistic_network
    if network == nil then return end

    for _, network in pairs(storage.logisticNetworks) do
        if table.contains(network, logisticCell) then
            table.remove_key(network, logisticCell)
            game.print("no-Logistics cell " .. entity.name)
            storage.logisticCells[entity] = nil
        end
    end
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
