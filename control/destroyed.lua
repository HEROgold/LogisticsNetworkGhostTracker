require("control.tracking")

function untrack_entity(entity)
    -- untrack_logistic_cell(entity)
    -- untrack_ghost_tracker(entity)
    -- untrack_ghost(entity)

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
