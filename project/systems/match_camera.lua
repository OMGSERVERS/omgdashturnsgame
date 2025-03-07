local match_camera
match_camera = {
	CAMERA_SMOOTH=0.05,
	-- Methods
	create = function(self)

		local bound_position = function(components, position)
			local bounds = components.level_state:get_level_bounds()
			
			local match_camera_component_url = components.screen_state:get_match_camera_component_url()
			
			local camera_projection = camera.get_projection(match_camera_component_url)
			local screen_width_half = 1 / camera_projection.m00 
			local screen_height_half = 1 / camera_projection.m11
			
			local position_z = position.z
			
			local min_x = bounds.x + screen_width_half
			local min_y = bounds.y + screen_height_half
			local min_position = vmath.vector3(min_x, min_y, position_z)
			
			local max_x = bounds.x + bounds.w - screen_width_half
			local max_y = bounds.y + bounds.h - screen_height_half
			local max_position = vmath.vector3(max_x, max_y, position_z)
			
			return vmath.clamp(position, min_position, max_position)
		end
		
		return {
			qualifier = "match_camera",
			update = function(instance, dt, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_match_screen() then
					return
				end

				local client_id = components.client_state:get_client_id()
				if client_id then
					local match_camera_url = components.screen_state:get_match_camera_url()
					local player_url = components.level_state:get_player_url(client_id)

					if match_camera_url and player_url then
						local camera_position = go.get_position(match_camera_url)
						local player_position = bound_position(components, go.get_position(player_url))
						
						local new_position = camera_position + (player_position - camera_position) * match_camera.CAMERA_SMOOTH
						new_position.z = camera_position.z

						go.set_position(new_position, match_camera_url)
					end
				end
			end
		}
	end
}

return match_camera