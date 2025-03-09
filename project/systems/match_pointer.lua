local game_events = require("project.messages.game_events")

local match_pointer
match_pointer = {
	-- Methods
	create = function(self)

		local function screen_to_world(components, x, y, z)
			local match_camera_component_url = components.screen_state:get_match_camera_component_url()
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
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_match_screen() then
					return
				end
				
				return true
			end,
			player_pointed = function(instance, components, event)
				local x = event.x
				local y = event.y

				local world_x, world_y = screen_to_world(components, x, y, 0)
				local world_z = world_y
				local match_pointer_url = components.screen_state:get_match_pointer_url()
				local position = vmath.vector3(world_x, world_y, world_z)
				go.set_position(position, match_pointer_url)

				local new_event = game_events:pointer_placed(world_x, world_y)
				components.game_events:add_event(new_event)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return match_pointer