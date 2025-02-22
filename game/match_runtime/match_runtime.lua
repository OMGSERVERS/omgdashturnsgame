local match_runtime
match_runtime = {
	RECEIVER = "/match_runtime#match_runtime",
	-- Events
	COMMAND_RECEIVED = "command_received",
	MESSAGE_RECEIVED = "message_received",
	-- Methods
	command_received = function(self, command_qualifier, command_body)
		return {
			command_qualifier = command_qualifier,
			command_body = command_body,
		}
	end,
	message_received = function(self, client_id, message)
		return {
			client_id = client_id,
			message = message,
		}
	end,
}

return match_runtime