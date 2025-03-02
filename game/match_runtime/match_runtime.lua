local match_runtime
match_runtime = {
	RECEIVER = "/match_runtime#match_runtime",
	-- Constants
	MATCH_LIFEIMTE = 256,
	STEP_INTERVAL = 2,
	-- Request
	SETUP_RUNTIME = "setup_runtime",
	-- Events
	COMMAND_RECEIVED = "command_received",
	MESSAGE_RECEIVED = "message_received",
	-- Methods
	setup_runtime = function(self)
		msg.post(self.RECEIVER, self.SETUP_RUNTIME, {
		});
	end,
	command_received = function(self, command_qualifier, command_body)
		msg.post(self.RECEIVER, self.COMMAND_RECEIVED, {
			command_qualifier = command_qualifier,
			command_body = command_body,
		});
	end,
	message_received = function(self, client_id, message)
		msg.post(self.RECEIVER, self.MESSAGE_RECEIVED, {
			client_id = client_id,
			message = message,
		})
	end,
}

return match_runtime