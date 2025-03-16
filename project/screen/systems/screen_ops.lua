local defold_ops_screen = require("project.defold.ops_screen.ops_screen")

local screen_ops
screen_ops = {
	create = function(self)
		return {
			qualifier = "screen_ops",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				if not components.client.screen:is_ops_screen() then
					return
				end

				return true
			end,
			ops_screen_created = function(instance, components, event)
				local state_text = components.screen.ops:get_state_text()
				local screen_url = components.client.screen:get_ops_screen_url()
				defold_ops_screen:change_screen(screen_url, state_text)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return screen_ops