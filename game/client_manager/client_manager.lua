local client_manager
client_manager = {
	RECEIVER = "/client_manager#client_manager",
	-- Requests
	RESET = "reset",
	SIGN_IN = "sign_in",
	SEND_COMMAND = "send_command",
	SEND_MESSAGE = "send_message",
	RECONNECT = "reconnect",
	-- Methods
	reset = function(self)
		msg.post(self.RECEIVER, client_manager.RESET, {
		})
	end,
	sign_in = function(self, user_id, password)
		msg.post(self.RECEIVER, client_manager.SIGN_IN, {
			user_id = user_id,
			password = password,
		})
	end,
	send_command = function(self, message)
		msg.post(self.RECEIVER, client_manager.SEND_COMMAND, {
			message = message,
		})
	end,
	send_message = function(self, message)
		msg.post(self.RECEIVER, client_manager.SEND_MESSAGE, {
			message = message,
		})
	end,
	reconnect = function(self)
		msg.post(self.RECEIVER, client_manager.RECONNECT, {
		})
	end,
}

return client_manager