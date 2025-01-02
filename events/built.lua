require("control.built")

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
        track_entity(event.entity)
        return
    end
    if event.created_entity then
        track_entity(event.created_entity)
        return
    end
end)