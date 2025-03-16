local server_lobby
server_lobby = {
	-- Methods
	create = function(self)
		local counter = 0
		local config = nil
		local profiles = {}
		
		return {
			qualifier = "server_lobby",
			-- Methods
			get_next_id = function(instance)
				counter = counter + 1
				return counter
			end,
			set_config = function(instance, new_config)
				print(os.date() .. " [SERVER_LOBBY] Set config")
				pprint(new_config)
				config = new_config
			end,
			get_config = function(instance)
				return config
			end,
			add_profile = function(instance, client_id, wrapped_profile)
				profiles[client_id] = wrapped_profile
			end,
			get_profile = function(instance, client_id)
				return profiles[client_id]
			end,
			delete_profile = function(instance, client_id)
				profiles[client_id] = nil
			end,
		}
	end
}

return server_lobby