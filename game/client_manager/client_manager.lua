local client_state = require("game.client_manager.client_state")

local client_manager
client_manager = {
	RECEIVER = "/client_manager#client_manager",
	-- Requests
	START = "start",
	JOIN = "join",
	LEAVE = "leave",
	SPAWN = "spawn",
	MOVE = "move",
	RESET = "reset",
	-- Events
	SCREEN_CREATED = "screen_created",
	MATCH_CREATED = "match_created",
	-- Screen qualifiers
	AUTH_SCREEN = "auth_screen",
	LOBBY_SCREEN = "lobby_screen",
	JOINING_SCREEN = "joining_screen",
	MATCH_SCREEN = "match_screen",
	LEAVING_SCREEN = "leaving_screen",
	OPS_SCREEN = "ops_screen",
	-- Methods
	get_client_id = function(self)
		return client_state.client_id
	end,
	start = function(self)
		msg.post(self.RECEIVER, self.START, {
		})
	end,
	join = function(self, nickname)
		msg.post(self.RECEIVER, self.JOIN, {
			nickname = nickname,
		})
	end,
	leave = function(self)
		msg.post(self.RECEIVER, self.LEAVE, {
		})
	end,
	reset = function(self)
		msg.post(self.RECEIVER, self.RESET, {
		})
	end,
	spawn = function(self)
		msg.post(self.RECEIVER, client_manager.SPAWN, {
		})
	end,
	move = function(self, x, y)
		msg.post(self.RECEIVER, client_manager.MOVE, {
			x = x,
			y = y,
		})
	end,
	screen_created = function(self, screen_qualifier, collection_id)
		msg.post(self.RECEIVER, self.SCREEN_CREATED, {
			screen_qualifier = screen_qualifier,
			collection_id = collection_id,
		})
	end,
	match_created = function(self, message)
		msg.post(self.RECEIVER, self.MATCH_CREATED, message)
	end,
}

return client_manager