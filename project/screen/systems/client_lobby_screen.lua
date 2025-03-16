local defold_lobby_screen = require("project.defold.lobby_screen.lobby_screen")

local client_lobby_screen
client_lobby_screen = {
	create = function(self)
		return {
			qualifier = "client_lobby_screen",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_lobby_screen() then
					return
				end

				return true
			end,
			lobby_screen_created = function(instance, components, event)
				local screen_url = components.screen_state:get_lobby_screen_url()
				local profile = components.client_state:get_profile()
				defold_lobby_screen:setup_screen(screen_url, profile)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return client_lobby_screen