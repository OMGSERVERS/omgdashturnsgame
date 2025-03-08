local level_events
level_events = {
	PLAYER_CREATED = "player_created",
	-- Methods
	player_created = function(self, client_id)
		assert(client_id, "client_id is nil")
		return {
			id = level_events.PLAYER_CREATED,
			client_id = client_id,
		}
	end,
}

return level_events