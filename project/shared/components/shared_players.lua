local shared_players
shared_players = {
	-- Methods
	create = function(self)
		local wrapped_players = {}
		local players_index = {}

		return {
			qualifier = "shared_players",
			-- Methods
			reset_component = function(instance)
				wrapped_players = {}
				players_index = {}
			end,
			get_wrapped_players = function(instance)
				return wrapped_players
			end,
			add_wrapped_player = function(instance, wrapped_player)
				local client_id = wrapped_player:get_client_id()
				wrapped_players[client_id] = wrapped_player
				local player_url = wrapped_player:get_player_url()
				players_index[player_url] = client_id
			end,
			get_wrapped_player = function(instance, client_id)
				return wrapped_players[client_id]
			end,
			get_client_id = function(instance, player_url)
				return players_index[player_url]
			end,
			delete_player = function(instance, client_id)
				local wrapped_player = instance:get_wrapped_player(client_id)
				if wrapped_player then
					local player_url = wrapped_player:get_player_url()
					players_index[player_url] = nil
				end
				wrapped_players[client_id] = nil
			end,
		}
	end
}

return shared_players