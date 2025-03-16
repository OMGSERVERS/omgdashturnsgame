local omgruntime = require("omgservers.omgruntime.omgruntime")

local server_state
server_state = {
	-- Methods
	create = function(self)
		local current_omgruntime = nil
		local runtime_qualifier = nil
		
		return {
			qualifier = "server_state",
			-- Methods
			set_omgruntime = function(instance, new_omgruntime)
				print(os.date() .. " [SERVER_STATE] Set omgruntime")
				current_omgruntime = new_omgruntime
			end,
			get_omgruntime = function(instance)
				return current_omgruntime
			end,
			set_runtime_qualifier = function(instance, new_runtime_qualifier)
				print(os.date() .. " [SERVER_STATE] Set runtime qualifier, runtime_qualifier=" .. tostring(new_runtime_qualifier))
				runtime_qualifier = new_runtime_qualifier
			end,
			get_runtime_qualifier = function(instance)
				return runtime_qualifier
			end,
			is_lobby_runtime = function(instance)
				return runtime_qualifier == omgruntime.constants.LOBBY
			end,
			is_match_runtime = function(instance)
				return runtime_qualifier == omgruntime.constants.MATCH
			end
		}
	end
}

return server_state