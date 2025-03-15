local lobby_runtime
lobby_runtime = {
	-- Methods
	create = function(self)
		local counter = 0
		local config = nil
		local profiles = {}
		
		return {
			qualifier = "lobby_runtime",
			-- Methods
			get_next_id = function(instance)
				counter = counter + 1
				return counter
			end,
			set_config = function(instance, new_config)
				print(os.date() .. " [LOBBY_RUNTIME] Set config")
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

return lobby_runtime