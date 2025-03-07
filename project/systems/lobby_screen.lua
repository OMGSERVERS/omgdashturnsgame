local defold_lobby_screen = require("project.defold.lobby_screen.lobby_screen")
local client_events = require("project.messages.client_events")

local lobby_screen
lobby_screen = {
	create = function(self)
		return {
			qualifier = "lobby_screen",
			update = function(instance, dt, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_lobby_screen() then
					return
				end

				local events = components.game_events:get_events()
				for i = 1,#events do
					local event = events[i]
					local event_id = event.id
					if event_id == client_events.LOBBY_SCREEN_CREATED then
						local screen_url = components.screen_state:get_lobby_screen_url()
						local profile = components.client_state:get_profile()
						defold_lobby_screen:setup_screen(screen_url, profile)
					end
				end
			end
		}
	end
}

return lobby_screen