local client_events
client_events = {
	CLIENT_STARTED = "client_started",
	AUTH_SCREEN_CREATED = "auth_screen_created",
	LOBBY_SCREEN_CREATED = "lobby_screen_created",
	JOINING_SCREEN_CREATED = "joining_screen_created",
	MATCH_SCREEN_CREATED = "match_screen_created",
	OPS_SCREEN_CREATED = "ops_screen_created",
	SIGNED_UP = "signed_up",
	SIGNED_IN = "signed_in",
	GREETED = "greeted",
	ASSIGNED = "assigned",
	MESSAGE_RECEIVED = "message_received",
	CONNECTION_DISPATCHED = "connection_dispatched",
	CLIENT_FAILED = "client_failed",
	RESET_PRESSED = "reset_pressed",
	PROFILE_UPDATED = "profile_updated",
	STATE_RECEIVED = "state_received",
	EVENTS_RECEIVED = "events_received",
	JOIN_PRESSED = "join_pressed",
	LEVEL_CREATED = "level_created",
	-- Methods
	client_started = function(self)
		return {
			id = client_events.CLIENT_STARTED,
		}
	end,
	auth_screen_created = function(self)
		return {
			id = client_events.AUTH_SCREEN_CREATED,
		}
	end,
	lobby_screen_created = function(self)
		return {
			id = client_events.LOBBY_SCREEN_CREATED,
		}
	end,
	joining_screen_created = function(self)
		return {
			id = client_events.JOINING_SCREEN_CREATED,
		}
	end,
	match_screen_created = function(self)
		return {
			id = client_events.MATCH_SCREEN_CREATED,
		}
	end,
	ops_screen_created = function(self)
		return {
			id = client_events.OPS_SCREEN_CREATED,
		}
	end,
	signed_up = function(self, user_id, password)
		return {
			id = client_events.SIGNED_UP,
			user_id = user_id,
			password = password,
		}
	end,
	signed_in = function(self, client_id)
		return {
			id = client_events.SIGNED_IN,
			client_id = client_id,
		}
	end,
	greeted = function(self, version_id, version_created)
		return {
			id = client_events.GREETED,
			version_id = version_id,
			version_created = version_created,
		}
	end,
	assigned = function(self, runtime_qualifier, runtime_id)
		return {
			id = client_events.ASSIGNED,
			runtime_qualifier = runtime_qualifier,
			runtime_id =runtime_id,
		}
	end,
	message_received = function(self, decoded_message)
		return {
			id = client_events.MESSAGE_RECEIVED,
			decoded_message = decoded_message,
		}
	end,
	connection_dispatched = function(self)
		return {
			id = client_events.CONNECTION_DISPATCHED,
		}
	end,
	client_failed = function(self, reason)
		return {
			id = client_events.CLIENT_FAILED,
			reason = reason,
		}
	end,
	reset_pressed = function(self)
		return {
			id = client_events.RESET_PRESSED,
		}
	end,
	profile_updated = function(self, profile)
		return {
			id = client_events.PROFILE_UPDATED,
			profile = profile,
		}
	end,
	state_received = function(self)
		return {
			id = client_events.STATE_RECEIVED,
		}
	end,
	events_received = function(self, events)
		return {
			id = client_events.EVENTS_RECEIVED,
			events = events,
		}
	end,
	join_pressed = function(self, nickname)
		return {
			id = client_events.JOIN_PRESSED,
			nickname = nickname,
		}
	end,
	level_created = function(self)
		return {
			id = client_events.LEVEL_CREATED,
		}
	end,
}

return client_events