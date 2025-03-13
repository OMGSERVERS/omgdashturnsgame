local level_state
level_state = {
	FOREST_LEVEL = "forest_level",
	-- Methods
	create = function(self)
		local qualifier = nil
		local collection_ids = nil
		local bounds = nil
		local players = nil
		local index = nil
		local movements = nil
		local kills = nil
		local spawn_points = nil
		
		return {
			qualifier = "level_state",
			-- Methods
			get_level_qualifier = function(instance)
				return qualifier
			end,
			get_collection_ids = function(instance)
				return collection_ids
			end,
			reset_state = function(instance)
				qualifier = nil
				collection_ids = nil
				bounds = nil
				players = nil
				index = nil
				movements = nil
				kills = nil
				spawn_points = nil
			end,
			set_level = function(instance, level_qualifier, level_collection_ids, level_bounds, level_spawn_points)
				print(os.date() .. " [LEVEL_STATE] Set level, spawn_points=" .. #level_spawn_points)
				qualifier = level_qualifier
				collection_ids = level_collection_ids
				bounds = level_bounds
				players = {}
				index = {}
				movements = {}
				kills = {}
				spawn_points = level_spawn_points
			end,
			get_level_bounds = function(instance)
				return bounds
			end,
			get_random_spawn_position = function(instance)
				if spawn_points then
					return spawn_points[math.random(#spawn_points)]
				end
			end,
			get_camera_point_url = function(instance)
				if collection_ids then
					local camera_point = collection_ids["/camera_point"]
					return camera_point
				else
					print(os.date() .. " [LEVEL_STATE] Collection ids is not set")
				end
			end,
			get_level_tilemap_url = function(instance)
				if collection_ids then
					local level_tilemap = collection_ids["/level_tilemap"]
					return msg.url(nil, level_tilemap, "level_tilemap")
				else
					print(os.date() .. " [LEVEL_STATE] Collection ids is not set")
				end
			end,
			get_players = function(instance)
				return players
			end,
			get_player_factory_url = function(instance)
				if collection_ids then
					local player_factory = collection_ids["/player_factory"]
					return msg.url(nil, player_factory, "player_factory")
				else
					print(os.date() .. " [LEVEL_STATE] Collection ids is not set")
				end
			end,
			add_player = function(instance, client_id, player_collection_ids)
				if players then
					players[client_id] = {
						collection_ids = player_collection_ids
					}

					local player_url = player_collection_ids["/match_player"]
					index[player_url] = client_id
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			get_player = function(instance, client_id)
				if players then
					return players[client_id]
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			get_player_collection_ids = function(instance, client_id)
				if players then
					local player = players[client_id]
					if player then
						return player.collection_ids
					else
						print(os.date() .. " [LEVEL_STATE] Player was not found, client_id=" .. tostring(client_id))
					end
				end
			end,
			get_player_url = function(instance, client_id)
				if players then
					local player = players[client_id]
					if player then
						return player.collection_ids["/match_player"]
					else
						print(os.date() .. " [LEVEL_STATE] Player was not found, client_id=" .. tostring(client_id))
					end
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			get_client_id = function(instance, player_url)
				if index then
					return index[player_url]
				end
			end,
			get_player_nickname_component_url = function(instance, client_id)
				if players then
					local player = players[client_id]
					if player then
						local match_player_url = player.collection_ids["/match_player"]
						return msg.url(nil, match_player_url, "nickname")
					else
						print(os.date() .. " [LEVEL_STATE] Player was not found, client_id=" .. tostring(client_id))
					end
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			get_player_skin_url = function(instance, client_id)
				if players then
					local player = players[client_id]
					if player then
						return player.collection_ids["/skin"]
					else
						print(os.date() .. " [LEVEL_STATE] Player was not found, client_id=" .. tostring(client_id))
					end
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			get_weapon_left_hand_url = function(instance, client_id)
				if players then
					local player = players[client_id]
					if player then
						return player.collection_ids["/weapon_left_hand"]
					else
						print(os.date() .. " [LEVEL_STATE] Player was not found, client_id=" .. tostring(client_id))
					end
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			get_weapon_right_hand_url = function(instance, client_id)
				if players then
					local player = players[client_id]
					if player then
						return player.collection_ids["/weapon_right_hand"]
					else
						print(os.date() .. " [LEVEL_STATE] Player was not found, client_id=" .. tostring(client_id))
					end
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			delete_player = function(instance, client_id)
				if players then
					local player_url = instance:get_player_url(client_id)
					if player_url then
						index[player_url] = nil
					end
					players[client_id] = nil
				else
					print(os.date() .. " [LEVEL_STATE] Players is not set")
				end
			end,
			add_movement = function(instance, client_id, movement)
				assert(players, "level is not set")
				local player = players[client_id]
				if player then
					movements[client_id] = movement
					print(os.date() .. " [LEVEL_STATE] Movement was added, client_id=" .. tostring(client_id))
				else
					print(os.date() .. " [LEVEL_STATE] Player was not found, client_id=" .. tostring(client_id))
				end
			end,
			get_movement = function(instance, client_id)
				assert(movements, "level is not set")
				return movements[client_id]
			end,
			get_movements = function(instance)
				return movements
			end,
			delete_movement = function(instance, client_id)
				movements[client_id] = nil
			end,
			add_kill = function(instance, client_id, killer_id)
				kills[killer_id] = {
					client_id = client_id
				}
				print(os.date() .. " [LEVEL_STATE] Kill was added, client_id=" .. tostring(client_id) .. ", killer_id=" .. killer_id)
			end,
			get_kill = function(instance, killer_id)
				assert(kills, "level is not set")
				return kills[killer_id]
			end,
			delete_kill = function(instance, killer_id)
				kills[killer_id] = nil
			end,
		}
	end
}

return level_state