local match_log
match_log = {
	RECEIVER = "match_log#match_log",
	-- Events
	PLAYER_JOINED = "player_joined",
	PLAYER_SPAWNED = "player_spawned",
	PLAYER_LEAVED = "player_leaved",
	PLAYER_KILLED = "player_killed",
	-- Methods
	player_joined = function(self, nickname)
		msg.post(self.RECEIVER, match_log.PLAYER_JOINED, {
			nickname = nickname,
		})
	end,
	player_spawned = function(self, nickname)
		msg.post(self.RECEIVER, match_log.PLAYER_SPAWNED, {
			nickname = nickname,
		})
	end,
	player_leaved = function(self, nickname)
		msg.post(self.RECEIVER, match_log.PLAYER_LEAVED, {
			nickname = nickname,
		})
	end,
	player_killed = function(self, killed, killer)
		msg.post(self.RECEIVER, match_log.PLAYER_KILLED, {
			killed = killed,
			killer = killer,
		})
	end,
}

return match_log