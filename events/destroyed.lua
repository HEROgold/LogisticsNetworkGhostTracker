local Entity = require("__heroic-library__.entity")
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
	function(event)
		local e = Entity.from_event(event)
		if not e or not e:is_valid() then
			return
		end
		unregister_ghost_combinator(event.entity)
		untrack_entity(event.entity)
	end
)
