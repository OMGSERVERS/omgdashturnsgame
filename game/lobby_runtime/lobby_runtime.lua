local lobby_runtime
lobby_runtime = {
	RECEIVER = "/lobby_runtime#lobby_runtime",
	-- Events
	COMMAND_RECEIVED = "command_received",
	MESSAGE_RECEIVED = "message_received",
	-- Methods
	command_received = function(self, command_qualifier, command_body)
		msg.post(self.RECEIVER, self.COMMAND_RECEIVED, {
			command_qualifier = command_qualifier,
			command_body = command_body,
		})
	end,
}

return lobby_runtime