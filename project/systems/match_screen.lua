local game_events = require("project.messages.game_events")

local match_screen
match_screen = {
	create = function(self)
		return {
			qualifier = "match_screen",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_match_screen() then
					return
				end

				return true
			end,
			update = function(instance, dt, components)
				local events = components.game_events:get_events()
				for i = 1,#events do
					local game_event = events[i]
					local game_event_id = game_event.id

					if game_event_id == game_events.LEVEL_CREATED then
						print(os.date() .. " [MATCH_SCREEN] Level created, setting match camera")
						local match_camera_url = components.screen_state:get_match_camera_url()
						local camera_position = go.get_position(match_camera_url)
						
						local camera_point_url = components.level_state:get_camera_point_url()
						local point_position = go.get_position(camera_point_url)

						local initial_position = vmath.vector3(point_position.x, point_position.y, camera_position.z)
						print(os.date() .. " [MATCH_SCREEN] New camera position is " .. initial_position)
						go.set_position(initial_position, match_camera_url)
					end
				end
			end
		}
	end
}

return match_screen
