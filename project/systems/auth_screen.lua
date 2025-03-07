local defold_auth_screen = require("project.defold.auth_screen.auth_screen")

local auth_screen
auth_screen = {
	create = function(self)
		return {
			qualifier = "auth_screen",
			update = function(instance, dt, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_auth_screen() then
					return
				end

				local state_text = components.auth_screen:get_state_text()
				local auth_screen_url = components.screen_state:get_auth_screen_url()
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

return auth_screen