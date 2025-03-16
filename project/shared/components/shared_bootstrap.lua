local shared_bootstrap
shared_bootstrap = {
	CLIENT = "client",
	SERVER = "server",
	-- Methods
	create = function(self)
		local mode = nil
		return {
			qualifier = "shared_bootstrap",
			-- Methods
			is_mode_set = function(instance)
				return mode ~= nil
			end,
			is_client_mode = function(instance)
				return mode == shared_bootstrap.CLIENT
			end,
			is_server_mode = function(instance)
				return mode == shared_bootstrap.SERVER
			end,
			set_client_mode = function(instance)
				mode = shared_bootstrap.CLIENT
			end,
			set_server_mode = function(instance)
				mode = shared_bootstrap.SERVER
			end,
		}
	end
}

return shared_bootstrap