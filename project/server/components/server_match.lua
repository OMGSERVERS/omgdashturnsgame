local server_match
server_match = {
	-- Methods
	create = function(self)
		local config = nil
		local profiles = {}
		local requests = {}
		
		return {
			qualifier = "server_match",
			-- Methods
			set_config = function(instance, new_config)
				print(os.date() .. " [SERVER_MATCH] Set config")
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
			add_request = function(instance, request)
				requests[#requests + 1] = request
			end,
			pull_requests = function(instance)
				local pulled_requests = requests
				requests = {}
				return pulled_requests
			end,
		}
	end
}

return server_match