local entrypoint_state
entrypoint_state = {
	CLIENT = "client",
	SERVER = "server",
	-- Methods
	create = function(self)
		local mode = nil
		return {
			qualifier = "entrypoint_state",
			-- Methods
			is_mode_set = function(instance)
				return mode ~= nil
			end,
			is_client_mode = function(instance)
				return mode == entrypoint_state.CLIENT
			end,
			is_server_mode = function(instance)
				return mode == entrypoint_state.SERVER
			end,
			set_client_mode = function(instance)
				assert(mode == nil, "mode was already set")
				mode = entrypoint_state.CLIENT
			end,
			set_server_mode = function(instance)
				assert(mode == nil, "mode was already set")
				mode = entrypoint_state.SERVER
			end,
		}
	end
}

return entrypoint_state