local screen_match
screen_match = {
	create = function(self)
		return {
			qualifier = "screen_match",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				if not components.client.screen:is_match_screen() then
					return
				end

				return true
			end,
			level_created = function(instance, components, event)
				print(os.date() .. " [SCREEN_MATCH] Level created, setting match camera")
				local match_camera_url = components.client.screen:get_match_camera_url()
				local camera_position = go.get_position(match_camera_url)

				local wrapped_level = components.shared.level:get_wrapped_level()
				local camera_point_url = wrapped_level:get_camera_point_url()
				local point_position = go.get_position(camera_point_url)

				local initial_position = vmath.vector3(point_position.x, point_position.y, camera_position.z)
				print(os.date() .. " [SCREEN_MATCH] New camera position is " .. initial_position)
				go.set_position(initial_position, match_camera_url)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return screen_match