local client_state
client_state = {
	IN_AUTH = "in_auth",
	GETTING_PROFILE = "getting_profile",
	IN_LOBBY = "in_lobby",
	JOINING = "joining",
	GETTING_STATE = "getting_state",
	IN_MATCH = "in_match",
	GAME_FAILED = "game_failed",
	LEAVING = "leaving",
	-- Methods
	create = function(self)
		local state = nil
		local client_id = nil
		local profile = nil
		local omginstance = nil
		return {
			qualifier = "client_state",
			-- Methods
			set_in_auth_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.IN_AUTH)
				state = client_state.IN_AUTH
			end,
			set_getting_profile_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.GETTING_PROFILE)
				state = client_state.GETTING_PROFILE
			end,
			is_getting_profile_state = function(instance)
				return state == client_state.GETTING_PROFILE
			end,
			set_in_lobby_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.IN_LOBBY)
				state = client_state.IN_LOBBY
			end,
			set_joining_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.JOINING)
				state = client_state.JOINING
			end,
			set_getting_state_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.GETTING_STATE)
				state = client_state.GETTING_STATE
			end,
			is_getting_state_state = function(instance)
				return state == client_state.GETTING_STATE
			end,
			set_in_match_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.IN_MATCH)
				state = client_state.IN_MATCH
			end,
			set_game_failed_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.GAME_FAILED)
				state = client_state.GAME_FAILED
			end,
			set_leaving_state = function(instance)
				print(os.date() .. " [CLIENT_STATE] Set " .. tostring(state) .. "->" .. client_state.LEAVING)
				state = client_state.LEAVING
			end,
			get_current_state = function(instance)
				return state
			end,
			set_omginstance = function(instance, new_omginstance)
				print(os.date() .. " [CLIENT_STATE] Set omginstance")
				omginstance = new_omginstance
			end,
			get_omginstance = function(instance)
				return omginstance
			end,
			set_client_id = function(instance, new_client_id)
				print(os.date() .. " [CLIENT_STATE] Set client id, client_id=" .. tostring(new_client_id))
				client_id = new_client_id
			end,
			get_client_id = function(instance)
				return client_id
			end,
			set_profile = function(instance, new_profile)
				print(os.date() .. " [CLIENT_STATE] Set profile")
				profile = new_profile
			end,
			get_profile = function(instance)
				return profile
			end,
			set_nickname = function(instance, new_nickname)
				assert(profile, "profile is nil")
				
				print(os.date() .. " [CLIENT_STATE] Set nickname -> " .. tostring(new_nickname))
				profile.data.nickname = new_nickname
			end,
			get_nickname = function(instance)
				assert(profile, "profile is nil")
				return profile.data.nickname
			end,
			reset_state = function(instance)
				state = nil
				client_id = nil
				profile = nil
			end
		}
	end
}

return client_state