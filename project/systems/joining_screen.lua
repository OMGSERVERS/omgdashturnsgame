local defold_joining_screen = require("project.defold.joining_screen.joining_screen")

local joining_screen
joining_screen = {
	create = function(self)
		return {
			qualifier = "joining_screen",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_joining_screen() then
					return
				end

				return true
			end,
			update = function(instance, dt, components)
				local state_text = components.joining_screen:get_state_text()
				local joining_screen_url = components.screen_state:get_joining_screen_url()
				if state_text then
					local dots_number = math.fmod(math.floor(socket.gettime() * 3), 4)
					local new_text = state_text .. string.rep(".", dots_number)
					defold_joining_screen:change_screen(joining_screen_url, new_text)
				else
					defold_joining_screen:change_screen(joining_screen_url, "")
				end
			end
		}
	end
}

return joining_screen