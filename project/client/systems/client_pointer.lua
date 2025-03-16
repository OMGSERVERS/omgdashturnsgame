local game_events = require("project.message.game_events")

local client_pointer
client_pointer = {
	-- Methods
	create = function(self)

		local function screen_to_world(components, x, y, z)
			local match_camera_component_url = components.client.screen:get_match_camera_component_url()
			local projection = go.get(match_camera_component_url, "projection")
			local view = go.get(match_camera_component_url, "view")
			local w, h = window.get_size()
			-- The window.get_size() function will return the scaled window size,
			-- ie taking into account display scaling (Retina screens on macOS for
			-- instance). We need to adjust for display scaling in our calculation.
			w = w / (w / 640)
			h = h / (h / 480)

			-- https://defold.com/manuals/camera/#converting-mouse-to-world-coordinates
			local inv = vmath.inv(projection * view)
			x = (2 * x / w) - 1
			y = (2 * y / h) - 1
			z = (2 * z) - 1
			local x1 = x * inv.m00 + y * inv.m01 + z * inv.m02 + inv.m03
			local y1 = x * inv.m10 + y * inv.m11 + z * inv.m12 + inv.m13
			local z1 = x * inv.m20 + y * inv.m21 + z * inv.m22 + inv.m23
			return x1, y1, z1
		end
		
		return {
			qualifier = "match_pointer",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				if not components.client.screen:is_match_screen() then
					return
				end
				
				return true
			end,
			player_pointed = function(instance, components, event)
				local x = event.x
				local y = event.y

				local world_x, world_y = screen_to_world(components, x, y, 0)
				local world_z = world_y
				local match_pointer_url = components.client.screen:get_match_pointer_url()
				-- -1 to ensure the pointer is below the player
				local position = vmath.vector3(world_x, world_y - 1, world_z)
				go.set_position(position, match_pointer_url)
				msg.post(match_pointer_url, "enable")

				local new_event = game_events:pointer_placed(world_x, world_y)
				components.shared.events:add_event(new_event)
			end,
			movement_created = function(instance, components, event)
				local client_id = event.client_id

				if client_id == components.client.state:get_client_id() then
					print(os.date() .. " [CLIENT_POINTER] This player's movement created, client_id=" .. tostring(client_id))
					local match_pointer_url = components.client.screen:get_match_pointer_url()
					msg.post(match_pointer_url, "disable")
				end
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return client_pointer