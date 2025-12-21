require("__heroic-library__.vars.words")

script.on_init(function ()
    ---@type table<LuaEntity, {logisticCell: LuaLogisticCell, entities: LuaEntity[]}>
    storage.logisticCells = {}
    ---@type table<LuaLogisticNetwork, {logisticCells: LuaEntity[]}>
    storage.logisticNetworks = {}
    ---@type {logisticCells: LuaEntity[]}
    storage.trackers = {}
    ---@type table<integer, LuaEntity>
    storage.combinators = {}

    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered{type = Roboport}) do
            track_entity(entity)
        end
        for _, entity in pairs(surface.find_entities_filtered{name = GhostCombinator}) do
            register_ghost_combinator(entity)
        end
    end
end)


