local defold_lobby_screen = require("project.defold.lobby_screen.lobby_screen")

local screen_lobby
screen_lobby = {
	create = function(self)
		return {
			qualifier = "screen_lobby",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				if not components.client.screen:is_lobby_screen() then
					return
				end

				return true
			end,
			lobby_screen_created = function(instance, components, event)
				local screen_url = components.client.screen:get_lobby_screen_url()
				local profile = components.client.state:get_profile()
				defold_lobby_screen:setup_screen(screen_url, profile)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return screen_lobby