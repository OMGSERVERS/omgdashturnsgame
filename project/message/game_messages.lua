local game_messages
game_messages = {
	REQUEST_PROFILE = "request_profile",
	REQUEST_MATCHMAKING = "request_matchmaking",
	REQUEST_STATE = "request_state",
	REQUEST_SPAWN = "request_spawn",
	REQUEST_LEAVE = "request_leave",
	REQUEST_MOVE = "request_move",
	-- Methods
	request_profile = function(self)
		return {
			qualifier = game_messages.REQUEST_PROFILE,
		}
	end,
	request_matchmaking = function(self, nickname)
		return {
			qualifier = game_messages.REQUEST_MATCHMAKING,
			nickname = nickname,
		}
	end,
	request_state = function(self)
		return {
			qualifier = game_messages.REQUEST_STATE,
		}
	end,
	request_spawn = function(self)
		return {
			qualifier = game_messages.REQUEST_SPAWN,
		}
	end,
	request_move = function(self, x, y)
		return {
			qualifier = game_messages.REQUEST_MOVE,
			x = x,
			y = y,
		}
	end,
	request_leave = function(self)
		return {
			qualifier = game_messages.REQUEST_LEAVE,
		}
	end
}

return game_messages