local defold_ops_screen = require("project.defold.ops_screen.ops_screen")
local client_events = require("project.messages.client_events")

local ops_screen
ops_screen = {
	create = function(self)
		return {
			qualifier = "ops_screen",
			update = function(instance, dt, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_ops_screen() then
					return
				end

				local events = components.game_events:get_events()
				for i = 1,#events do
					local event = events[i]
					local event_id = event.id
					if event_id == client_events.OPS_SCREEN_CREATED then
						local state_text = components.ops_screen:get_state_text()
						local screen_url = components.screen_state:get_ops_screen_url()
						defold_ops_screen:change_screen(screen_url, state_text)
					end
				end
			end
		}
	end
}

return ops_screen