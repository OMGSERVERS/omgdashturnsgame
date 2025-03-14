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
			level_created = function(instance, components, event)
				print(os.date() .. " [MATCH_SCREEN] Level created, setting match camera")
				local match_camera_url = components.screen_state:get_match_camera_url()
				local camera_position = go.get_position(match_camera_url)

				local wrapped_level = components.level_state:get_wrapped_level()
				local camera_point_url = wrapped_level:get_camera_point_url()
				local point_position = go.get_position(camera_point_url)

				local initial_position = vmath.vector3(point_position.x, point_position.y, camera_position.z)
				print(os.date() .. " [MATCH_SCREEN] New camera position is " .. initial_position)
				go.set_position(initial_position, match_camera_url)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return match_screen
