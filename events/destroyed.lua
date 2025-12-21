require("control.destroyed")
require("control.ghost-combinator")

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
        unregister_ghost_combinator(event.entity)
        untrack_entity(event.entity)
    end
)
