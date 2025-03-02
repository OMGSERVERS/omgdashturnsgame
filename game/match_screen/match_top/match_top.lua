local match_top
match_top = {
	RECEIVER = "match_top#match_top",
	-- Requests
	ADD_PLAYER = "add_player",
	DELETE_PLAYER = "delete_player",
	INCREASE_SCORE = "increase_score",
	-- Methods
	add_player = function(self, client_id, nickname, score)
		msg.post(self.RECEIVER, match_top.ADD_PLAYER, {
			client_id = client_id,
			nickname = nickname,
			score = score,
		})
	end,
	delete_player = function(self, client_id)
		msg.post(self.RECEIVER, match_top.DELETE_PLAYER, {
			client_id = client_id,
		})
	end,
	increase_score = function(self, client_id)
		msg.post(self.RECEIVER, match_top.INCREASE_SCORE, {
			client_id = client_id,
		})
	end,
}

return match_top