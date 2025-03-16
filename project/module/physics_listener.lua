local game_events = require("project.message.game_events")

local physics_listener
physics_listener = {
	-- Methods
	create = function(self, components)

		return function(self, event, data)
			if event == hash("contact_point_event") then
				local a_url = data.a.id
				local a_position = data.a.instance_position
				local a_group = data.a.group

				local b_url = data.b.id
				local b_position = data.b.instance_position
				local b_group = data.b.group

				if a_group == hash("players") and b_group == hash("players") then
					local new_event = game_events:collision_detected(a_url, a_position, b_url, b_position)
					components.game_events:add_event(new_event)
				end
			end
		end
	end,
}

return physics_listener