local screen_factory
screen_factory = {
	RECEIVER = "/screen_factory#screen_factory",
	-- Requests
	CREATE_AUTH_SCREEN = "create_auth_screen",
	CREATE_LOBBY_SCREEN = "create_lobby_screen",
	CREATE_MATCH_SCREEN = "create_match_screen",
	CREATE_JOINING_SCREEN = "create_joining_screen",
	CREATE_LEAVING_SCREEN = "create_leaving_screen",
	CREATE_OPS_SCREEN = "create_ops_screen",
	-- Screen qualifiers
	AUTH_SCREEN = "auth_screen",
	LOBBY_SCREEN = "lobby_screen",
	JOINING_SCREEN = "joining_screen",
	MATCH_SCREEN = "match_screen",
	LEAVING_SCREEN = "leaving_screen",
	OPS_SCREEN = "ops_screen",
	-- Methods
	create_auth_screen = function(self)
		msg.post(self.RECEIVER, self.CREATE_AUTH_SCREEN, {
		})
	end,
	create_lobby_screen = function(self, profile)
		msg.post(self.RECEIVER, self.CREATE_LOBBY_SCREEN, {
			profile = profile,
		})
	end,
	create_joining_screen = function(self)
		msg.post(self.RECEIVER, self.CREATE_JOINING_SCREEN, {
		})
	end,
	create_match_screen = function(self, game_manager_url, settings, match_state, step_index)
		msg.post(self.RECEIVER, self.CREATE_MATCH_SCREEN, {
			game_manager_url = game_manager_url,
			settings = settings,
			match_state = match_state,
			step_index = step_index,
		})
	end,
	create_leaving_screen = function(self)
		msg.post(self.RECEIVER, self.CREATE_LEAVING_SCREEN, {
		})
	end,
	create_ops_screen = function(self, reason)
		msg.post(self.RECEIVER, self.CREATE_OPS_SCREEN, {
			reason = reason
		})
	end,
}

return screen_factory