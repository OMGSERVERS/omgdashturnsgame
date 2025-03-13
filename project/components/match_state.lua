local match_events = require("project.messages.match_events")

local match_state
match_state = {
	DEATH_MATCH = "death_match",
	-- Methods
	create = function(self)
		local qualifier = match_state.DEATH_MATCH
		local settings = {
			level = nil,
		}
		local state = {
			clients = {},
			players = {}
		}
		local events = {}
		local step = 0
		
		return {
			qualifier = "match_state",
			-- Methods
			init_state = function(instance, new_settings)
				print(os.date() .. " [MATCH_STATE] Initialize match state")
				settings = new_settings
				state = {
					clients = {},
					players = {},
				}
				events = {}
				step = 0
			end,
			set_state = function(instance, new_settings, new_state, new_step)
				print(os.date() .. " [MATCH_STATE] Set match state, step=" .. tostring(new_step))
				print(os.date() .. " [MATCH_STATE] Settings:")
				pprint(new_settings)
				print(os.date() .. " [MATCH_STATE] State:")
				pprint(new_state)
				
				settings = new_settings
				state = new_state
				step = new_step

				events = {}
			end,
			is_death_match = function()
				return qualifier == match_state.DEATH_MATCH
			end,
			get_settings = function()
				return settings
			end,
			get_level_qualifier = function()
				return settings.match_level
			end,
			get_state = function()
				return state
			end,
			get_step = function()
				return step
			end,
			set_step = function(new_step)
				step = new_step
			end,
			get_events = function(instance)
				return events
			end,
			reset_events = function(instance)
				events = {}
			end,
			add_client = function(instance, client_id, nickname, score)
				state.clients[client_id] = {
					nickname = nickname,
					score = score,
				}

				local match_event = match_events:client_added(client_id, nickname, score)
				events[#events + 1] = match_event
			end,
			get_nickname = function(instance, client_id)
				return state.clients[client_id].nickname
			end,
			add_player = function(instance, client_id, x, y)
				state.players[client_id] = {
					x = x,
					y = y,
				}
				local match_event = match_events:player_created(client_id, x, y)
				events[#events + 1] = match_event
			end,
			move_player = function(instance, client_id, x, y)
				local player = state.players[client_id]
				if player then
					player.x = x
					player.y = y
				end
				local match_event = match_events:player_moved(client_id, x, y)
				events[#events + 1] = match_event
			end,
			kill_player = function(instance, client_id, killer_id)
				local player = state.players[client_id]
				if player then
					state.players[client_id] = nil
					local match_event = match_events:player_killed(client_id, killer_id)
					events[#events + 1] = match_event
				end
			end,
			delete_player = function(instance, client_id)
				local player = state.players[client_id]
				if player then
					state.players[client_id] = nil
					local match_event = match_events:player_deleted(client_id)
					events[#events + 1] = match_event
				end
			end,
			delete_client = function(instance, client_id)
				instance:delete_player(client_id)
				
				state.clients[client_id] = nil

				local match_event = match_events:client_deleted(client_id)
				events[#events + 1] = match_event
			end,
		}
	end
}

return match_state