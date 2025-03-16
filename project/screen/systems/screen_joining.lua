local defold_joining_screen = require("project.defold.joining_screen.joining_screen")

local screen_joining
screen_joining = {
	create = function(self)
		return {
			qualifier = "screen_joining",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				if not components.client.screen:is_joining_screen() then
					return
				end

				return true
			end,
			update = function(instance, dt, components)
				local state_text = components.screen.joining:get_state_text()
				local joining_screen_url = components.client.screen:get_joining_screen_url()
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

return screen_joining