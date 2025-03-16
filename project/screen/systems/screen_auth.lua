local defold_auth_screen = require("project.defold.auth_screen.auth_screen")

local screen_auth
screen_auth = {
	create = function(self)
		return {
			qualifier = "screen_auth",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				if not components.client.screen:is_auth_screen() then
					return
				end

				return true
			end,
			update = function(instance, dt, components)
				local state_text = components.screen.auth:get_state_text()
				local auth_screen_url = components.client.screen:get_auth_screen_url()
				if state_text then
					local dots_number = math.fmod(math.floor(socket.gettime() * 3), 4)
					local new_text = state_text .. string.rep(".", dots_number)
					defold_auth_screen:change_screen(auth_screen_url, new_text)
				else
					defold_auth_screen:change_screen(auth_screen_url, "")
				end
			end
		}
	end
}

return screen_auth