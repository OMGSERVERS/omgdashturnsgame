local client_camera
client_camera = {
	CAMERA_SMOOTH=0.05,
	-- Methods
	create = function(self)
		local bound_position = function(components, position)
			local bounds = components.shared.level:get_level_bounds()
			
			local match_camera_component_url = components.client.screen:get_match_camera_component_url()
			
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

		local reset_camera_zoom = function(components, window_width, window_height)
			local scale_x = window_width / sys.get_config_number("display.width")
			local scale_y = window_height / sys.get_config_number("display.height")
			local scale = math.ceil(math.max(scale_x, scale_y))

			local match_camera_component_url = components.client.screen:get_match_camera_component_url()
			go.set(match_camera_component_url, "orthographic_zoom", scale)
			
			print(os.date() .. " [CLIENT_CAMERA] Set zoom, orthographic_zoom=" .. tostring(scale))
		end
		
		return {
			qualifier = "client_camera",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end
				
				return true
			end,
			level_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_CAMERA] Level created, set window listener")
				
				window.set_listener(function(self, event, data)
					if event == window.WINDOW_EVENT_RESIZED then
						reset_camera_zoom(components, data.width, data.height)
					end
				end)

				local width, height = window.get_size()
				reset_camera_zoom(components, width, height)
			end,
			level_deleted = function(instance, components, event)
				print(os.date() .. " [CLIENT_CAMERA] Level deleted, delete window listener")
				window.set_listener(nil)
			end,
			update = function(instance, dt, components)
				if components.client.screen:is_match_screen() then
					local client_id = components.client.state:get_client_id()
					if client_id then
						local wrapped_player = components.shared.players:get_wrapped_player(client_id)
						if wrapped_player then
							local match_camera_url = components.client.screen:get_match_camera_url()
							local player_url = wrapped_player:get_player_url()

							if match_camera_url and player_url then
								local camera_position = go.get_position(match_camera_url)
								local player_position = bound_position(components, go.get_position(player_url))

								local new_position = camera_position + (player_position - camera_position) * client_camera.CAMERA_SMOOTH
								new_position.z = camera_position.z

								go.set_position(new_position, match_camera_url)
							end
						end
					end
				end
			end
		}
	end
}

return client_camera