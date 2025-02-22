local game_entrypoint
game_entrypoint = {
	RECEIVER = "/game_entrypoint#game_entrypoint",
	-- Events
	MATCH_CREATED = "match_created",
	-- Methods
	match_created = function(self, match_qualifier, collection_id)
		msg.post(self.RECEIVER, self.MATCH_CREATED, {
			match_qualifier = match_qualifier,
			collection_id = collection_id,
		})
	end,
}

return game_entrypoint