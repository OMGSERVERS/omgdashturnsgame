local game_events
game_events = {
	-- Client
	CLIENT_STARTED = "client_started",
	AUTH_SCREEN_CREATED = "auth_screen_created",
	LOBBY_SCREEN_CREATED = "lobby_screen_created",
	JOINING_SCREEN_CREATED = "joining_screen_created",
	MATCH_SCREEN_CREATED = "match_screen_created",
	LEAVING_SCREEN_CREATED = "leaving_screen_created",
	OPS_SCREEN_CREATED = "ops_screen_created",
	SIGNED_UP = "signed_up",
	SIGNED_IN = "signed_in",
	GREETED = "greeted",
	ASSIGNED = "assigned",
	SERVER_MESSAGE_RECEIVED = "server_message_received",
	CONNECTION_DISPATCHED = "connection_dispatched",
	CLIENT_FAILED = "client_failed",
	RESET_PRESSED = "reset_pressed",
	PROFILE_UPDATED = "profile_updated",
	STATE_RECEIVED = "state_received",
	EVENTS_RECEIVED = "events_received",
	JOIN_PRESSED = "join_pressed",
	LEVEL_CREATED = "level_created",
	LEAVE_PRESSED = "leave_pressed",
	PLAYER_POINTED = "player_pointed",
	POINTER_PLACED = "pointer_placed",
	-- Server
	SERVER_STARTED = "server_started",
	RUNTIME_STARTED = "runtime_started",
	COMMAND_RECEIVED = "command_received",
	CLIENT_MESSAGE_RECEIVED = "client_message_received",
	STATE_INITIALIZED = "state_initialized",
	MATCH_OVER = "match_over",
	STEP_OVER = "step_over",
	STEP_SIMULATED = "step_simulated",
	-- Shared
	PLAYER_CREATED = "player_created",
	PLAYER_MOVED = "player_moved",
	-- Methods
	client_started = function(self)
		return {
			id = game_events.CLIENT_STARTED,
		}
	end,
	auth_screen_created = function(self)
		return {
			id = game_events.AUTH_SCREEN_CREATED,
		}
	end,
	lobby_screen_created = function(self)
		return {
			id = game_events.LOBBY_SCREEN_CREATED,
		}
	end,
	joining_screen_created = function(self)
		return {
			id = game_events.JOINING_SCREEN_CREATED,
		}
	end,
	match_screen_created = function(self)
		return {
			id = game_events.MATCH_SCREEN_CREATED,
		}
	end,
	leaving_screen_created = function(self)
		return {
			id = game_events.LEAVING_SCREEN_CREATED,
		}
	end,
	ops_screen_created = function(self)
		return {
			id = game_events.OPS_SCREEN_CREATED,
		}
	end,
	signed_up = function(self, user_id, password)
		return {
			id = game_events.SIGNED_UP,
			user_id = user_id,
			password = password,
		}
	end,
	signed_in = function(self, client_id)
		return {
			id = game_events.SIGNED_IN,
			client_id = client_id,
		}
	end,
	greeted = function(self, version_id, version_created)
		return {
			id = game_events.GREETED,
			version_id = version_id,
			version_created = version_created,
		}
	end,
	assigned = function(self, runtime_qualifier, runtime_id)
		return {
			id = game_events.ASSIGNED,
			runtime_qualifier = runtime_qualifier,
			runtime_id =runtime_id,
		}
	end,
	server_message_received = function(self, decoded_message)
		return {
			id = game_events.SERVER_MESSAGE_RECEIVED,
			decoded_message = decoded_message,
		}
	end,
	connection_dispatched = function(self)
		return {
			id = game_events.CONNECTION_DISPATCHED,
		}
	end,
	client_failed = function(self, reason)
		return {
			id = game_events.CLIENT_FAILED,
			reason = reason,
		}
	end,
	reset_pressed = function(self)
		return {
			id = game_events.RESET_PRESSED,
		}
	end,
	profile_updated = function(self, profile)
		return {
			id = game_events.PROFILE_UPDATED,
			profile = profile,
		}
	end,
	state_received = function(self)
		return {
			id = game_events.STATE_RECEIVED,
		}
	end,
	events_received = function(self, events)
		return {
			id = game_events.EVENTS_RECEIVED,
			events = events,
		}
	end,
	join_pressed = function(self, nickname)
		return {
			id = game_events.JOIN_PRESSED,
			nickname = nickname,
		}
	end,
	level_created = function(self)
		return {
			id = game_events.LEVEL_CREATED,
		}
	end,
	server_started = function(self)
		return {
			id = game_events.SERVER_STARTED
		}
	end,
	runtime_started = function(self, runtime_qualifier)
		return {
			id = game_events.RUNTIME_STARTED,
			runtime_qualifier = runtime_qualifier,
		}
	end,
	command_received = function(self, command_qualifier, command_body)
		return {
			id = game_events.COMMAND_RECEIVED,
			command_qualifier = command_qualifier,
			command_body = command_body,
		}
	end,
	client_message_received = function(self, client_id, decoded_message)
		return {
			id = game_events.CLIENT_MESSAGE_RECEIVED,
			client_id = client_id,
			decoded_message = decoded_message,
		}
	end,
	state_initialized = function(self)
		return {
			id = game_events.STATE_INITIALIZED,
		}
	end,
	match_over = function(self)
		return {
			id = game_events.MATCH_OVER,
		}
	end,
	step_over = function(self, step_index)
		return {
			id = game_events.STEP_OVER,
			step_index = step_index,
		}
	end,
	step_simulated = function(self, events)
		return {
			id = game_events.STEP_SIMULATED,
			events = events,
		}
	end,
	player_created = function(self, client_id)
		assert(client_id, "client_id is nil")
		return {
			id = game_events.PLAYER_CREATED,
			client_id = client_id,
		}
	end,
	leave_pressed = function(self)
		return {
			id = game_events.LEAVE_PRESSED,
		}
	end,
	player_pointed = function(self, x, y)
		return {
			id = game_events.PLAYER_POINTED,
			x = x,
			y = y,
		}
	end,
	pointer_placed = function(self, x, y)
		return {
			id = game_events.POINTER_PLACED,
			x = x,
			y = y,
		}
	end,
	player_moved = function(self, client_id, x, y)
		return {
			id = game_events.PLAYER_MOVED,
			client_id = client_id,
			x = x,
			y = y,
		}
	end,
}

return game_events