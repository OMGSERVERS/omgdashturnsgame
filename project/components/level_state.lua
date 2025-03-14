local level_wrapper = require("project.utils.level_wrapper")

local level_state
level_state = {
	FOREST_LEVEL = "forest_level",
	-- Methods
	create = function(self)
		local qualifier = nil
		local wrapped_level = nil
		local wrapped_players = {}
		local players_index = {}

		local bounds = nil
		
		local kills = {}
		local spawn_points = {}
		
		return {
			qualifier = "level_state",
			-- Methods
			get_level_qualifier = function(instance)
				return qualifier
			end,
			get_wrapped_level = function(instance)
				return wrapped_level
			end,
			reset_component = function(instance)
				qualifier = nil
				wrapped_level = nil
				wrapped_players = {}
				players_index = {}
				
				bounds = nil
				kills = {}
				spawn_points = {}
			end,
			set_level = function(instance, level_qualifier, level_wrapped_level, level_bounds, level_spawn_points)
				assert(instance, "instance is nil")
				assert(level_qualifier, "level_qualifier is nil")
				assert(level_wrapped_level, "level_wrapped_level is nil")
				assert(level_bounds, "level_bounds is nil")
				assert(level_spawn_points, "level_spawn_points is nil")
				
				assert(level_wrapped_level.qualifier == level_wrapper.INSTANCE_QUALIFIER, "wrapped level qualifier is incorrect")
				
				print(os.date() .. " [LEVEL_STATE] Set level, spawn_points=" .. #level_spawn_points)
				qualifier = level_qualifier
				wrapped_level = level_wrapped_level
				bounds = level_bounds
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