local defold_ops_screen = require("project.defold.ops_screen.ops_screen")

local client_ops_screen
client_ops_screen = {
	create = function(self)
		return {
			qualifier = "client_ops_screen",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_ops_screen() then
					return
				end

				return true
			end,
			ops_screen_created = function(instance, components, event)
				local state_text = components.ops_screen:get_state_text()
				local screen_url = components.screen_state:get_ops_screen_url()
				defold_ops_screen:change_screen(screen_url, state_text)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return client_ops_screen