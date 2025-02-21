local client_state = require("game.client_manager.client_state")

local client_manager
client_manager = {
	RECEIVER = "/client_manager#client_manager",
	-- 
	GAME_STARTED = "game_started",
	GAME_FAILED = "game_failed",
	SCREEN_CREATED = "screen_created",
	SIGNED_UP = "signed_up",
	SIGNED_IN = "signed_in",
	USER_GREETED = "user_greeted",
	RUNTIME_ASSIGNED = "runtime_assigned",
	MESSAGE_RECEIVED = "message_received",
	CONNECTION_UPGRADED = "connection_upgraded",
	JOINING_REQUESTED = "joining_requested",
	LEAVING_REQUESTED = "leaving_requested",
	RESET_REQUESTED = "reset_requested",
	SPAWN = "spawn",
	MOVE = "move",
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
	game_started = function(self)
		msg.post(self.RECEIVER, client_manager.GAME_STARTED, {
		})
	end,
	screen_created = function(self, screen_qualifier, collection_id)
		msg.post(self.RECEIVER, client_manager.SCREEN_CREATED, {
			screen_qualifier = screen_qualifier,
			collection_id = collection_id,
		})
	end,
	signed_up = function(self, user_id, password)
		msg.post(self.RECEIVER, client_manager.SIGNED_UP, {
			user_id = user_id,
			password = password,
		})
	end,
	signed_in = function(self, client_id)
		msg.post(self.RECEIVER, client_manager.SIGNED_IN, {
			client_id = client_id,
		})
	end,
	user_greeted = function(self, version_id, version_created)
		msg.post(self.RECEIVER, client_manager.USER_GREETED, {
			version_id = version_id,
			version_created = version_created,
		})
	end,
	runtime_assigned = function(self, runtime_qualifier, runtime_id)
		msg.post(self.RECEIVER, client_manager.RUNTIME_ASSIGNED, {
			runtime_qualifier = runtime_qualifier,
			runtime_id = runtime_id,
		})
	end,
	message_received = function(self, message)
		-- send message as is
		msg.post(self.RECEIVER, client_manager.MESSAGE_RECEIVED, message)
	end,
	connection_upgraded = function(self)
		msg.post(self.RECEIVER, client_manager.CONNECTION_UPGRADED, {
		})
	end,
	joining_requested = function(self, nickname)
		msg.post(self.RECEIVER, client_manager.JOINING_REQUESTED, {
			nickname = nickname,
		})
	end,
	leaving_requested = function(self)
		msg.post(self.RECEIVER, client_manager.LEAVING_REQUESTED, {
		})
	end,
	reset_requested = function(self)
		msg.post(self.RECEIVER, client_manager.RESET_REQUESTED, {
		})
	end,
	game_failed = function(self, reason)
		msg.post(self.RECEIVER, client_manager.GAME_FAILED, {
			reason = reason
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
}

return client_manager