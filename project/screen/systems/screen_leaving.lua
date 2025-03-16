local defold_leaving_screen = require("project.defold.leaving_screen.leaving_screen")

local screen_leaving
screen_leaving = {
	create = function(self)
		return {
			qualifier = "screen_leaving",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				if not components.client.screen:is_leaving_screen() then
					return
				end

				return true
			end,
			update = function(instance, dt, components)
				local state_text = components.screen.leaving:get_state_text()
				local leaving_screen_url = components.client.screen:get_leaving_screen_url()
				if state_text then
					local dots_number = math.fmod(math.floor(socket.gettime() * 3), 4)
					local new_text = state_text .. string.rep(".", dots_number)
					defold_leaving_screen:change_screen(leaving_screen_url, new_text)
				else
					defold_leaving_screen:change_screen(leaving_screen_url, "")
				end
			end
		}
	end
}

return screen_leaving