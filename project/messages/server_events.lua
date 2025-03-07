local server_events
server_events = {
	SERVER_STARTED = "server_started",
	RUNTIME_STARTED = "runtime_started",
	COMMAND_RECEIVED = "command_received",
	MESSAGE_RECEIVED = "message_received",
	STATE_INITIALIZED = "state_initialized",
	MATCH_OVER = "match_over",
	STEP_OVER = "step_over",
	STEP_SIMULATED = "step_simulated",
	-- Methods
	server_started = function(self)
		return {
			id = server_events.SERVER_STARTED
		}
	end,
	runtime_started = function(self, runtime_qualifier)
		return {
			id = server_events.RUNTIME_STARTED,
			runtime_qualifier = runtime_qualifier,
		}
	end,
	command_received = function(self, command_qualifier, command_body)
		return {
			id = server_events.COMMAND_RECEIVED,
			command_qualifier = command_qualifier,
			command_body = command_body,
		}
	end,
	message_received = function(self, client_id, decoded_message)
		return {
			id = server_events.MESSAGE_RECEIVED,
			client_id = client_id,
			decoded_message = decoded_message,
		}
	end,
	state_initialized = function(self)
		return {
			id = server_events.STATE_INITIALIZED,
		}
	end,
	match_over = function(self)
		return {
			id = server_events.MATCH_OVER,
		}
	end,
	step_over = function(self, step_index)
		return {
			id = server_events.STEP_OVER,
			step_index = step_index,
		}
	end,
	step_simulated = function(self, events)
		return {
			id = server_events.STEP_SIMULATED,
			events = events,
		}
	end,
}

return server_events