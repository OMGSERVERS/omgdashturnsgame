local death_match = require("game.death_match.death_match")

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
	get_match_module = function(self, match_qualifier)
		if match_qualifier == self.DEATH_MATCH then
			return death_match
		else
			print(os.date() .. " [MATCH_FACTORY] Unknown qualifier to get match module, match_qualifier=" .. match_qualifier)
		end
	end,
	create_death_match = function(self, game_manager_url, settings, match_state, step_index)
		msg.post(self.RECEIVER, self.CREATE_DEATH_MATCH, {
			game_manager_url = game_manager_url,
			settings = settings,
			match_state = match_state,
			step_index = step_index,
		})
	end,
}

return match_factory