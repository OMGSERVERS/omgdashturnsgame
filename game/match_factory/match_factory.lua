local match_factory
match_factory = {
	RECEIVER = "/match_factory#match_factory",
	-- Requests
	CREATE_DEATH_MATCH = "create_death_match",
	-- Match qualifier
	DEATH_MATCH = "death_match",
	-- Level qualifiers
	FOREST_LEVEL = "forest_level",
	-- Methods
	create_death_match = function(self, level)
		msg.post(self.RECEIVER, self.CREATE_DEATH_MATCH, {
			level = level,
		})
	end,
}

return match_factory