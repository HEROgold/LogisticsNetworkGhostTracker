require("__heroic_library__.vars.words")

script.on_init(function ()
    ---@type table<LuaEntity, {logisticCell: LuaLogisticCell, entities: LuaEntity[]}>
    storage.logisticCells = {}
    ---@type table<LuaLogisticNetwork, {logisticCells: LuaEntity[]}>
    storage.logisticNetworks = {}
    ---@type {logisticCells: LuaEntity[]}
    storage.trackers = {}

    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered{type = Roboport}) do
            track_entity(entity)
        end
    end
end)


