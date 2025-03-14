local match_requests = require("project.messages.match_requests")
local match_events = require("project.messages.match_events")
local game_events = require("project.messages.game_events")
local level_utils = require("project.utils.level_utils")

local level_deathmatch
level_deathmatch = {
	create = function(self)
		return {
			qualifier = "death_match",
			predicate = function(instance, components)
				if not components.match_state:is_death_match() then
					return
				end
				
				return true
			end,
			step_over = function(instance, components, event)
				local step_index = event.step_index
				if components.death_match:is_simulation_state() then
					print(os.date() .. " [LEVEL_DEATHMATCH] Step is over, but match is still in simulation, step=" .. step_index)
				else
					print(os.date() .. " [LEVEL_DEATHMATCH] Step is over, step=" .. step_index)
					components.death_match:set_simulation_state()
				end

				components.match_state:set_step(step_index)
				components.match_state:reset_events()

				local pulled_requests = components.match_runtime:pull_requests()
				for request_index = 1,#pulled_requests do
					local request = pulled_requests[request_index]
					local qualifier = request.qualifier

					if qualifier == match_requests.ADD_CLIENT then
						local client_id = request.client_id
						local nickname = request.nickname
						local score = request.score

						print(os.date() .. " [LEVEL_DEATHMATCH] Add client, client_id=" .. client_id .. ", nickname=" .. nickname)
						components.match_state:add_client(client_id, nickname, score)

					elseif qualifier == match_requests.SPAWN_PLAYER then
						local client_id = request.client_id
						print(os.date() .. " [LEVEL_DEATHMATCH] Spawn player, client_id=" .. client_id)

						local spawn_position = components.level_state:get_random_spawn_position()
						if spawn_position then
							level_utils:create_player(components, client_id, spawn_position)
							components.match_state:add_player(client_id, spawn_position.x, spawn_position.y)
						else
							print(os.date() .. " [LEVEL_DEATHMATCH] Level bounds is not set to spawn player, client_id=" .. client_id)
						end

					elseif qualifier == match_requests.MOVE_PLAYER then
						local client_id = request.client_id
						local x = request.x
						local y = request.y

						print(os.date() .. " [LEVEL_DEATHMATCH] Move player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)
						if not components.level_movements:get_movement(client_id) then
							components.death_match:increase_movements()
						end
						level_utils:create_movement(components, client_id, x, y)

					elseif qualifier == match_requests.DELETE_PLAYER then
						local client_id = request.client_id

						print(os.date() .. " [LEVEL_DEATHMATCH] Delete player, client_id=" .. client_id)
						level_utils:delete_player(components, client_id)
						components.match_state:delete_player(client_id)

					elseif qualifier == match_requests.DELETE_CLIENT then
						local client_id = request.client_id
						print(os.date() .. " [LEVEL_DEATHMATCH] Delete client, client_id=" .. client_id)
						components.match_state:delete_client(client_id)
					end
				end
			end,
			level_created = function(instance, components, event)
				local state = components.match_state:get_state()

				local clients = state.clients
				for client_id, client in pairs(clients) do
					local nickname = client.nickname
					local score = client.score
					components.match_state:add_client(client_id, nickname, score)
				end

				local players = state.players
				for client_id, player in pairs(players) do
					local x = player.x
					local y = player.y
					local z = y
					local position = vmath.vector3(x, y, z)
					level_utils:create_player(components, client_id, position)
				end
			end,
			events_received = function(instance, components, event)
				local events = event.events
				print(os.date() .. " [LEVEL_DEATHMATCH] Events were received, total=" .. #events)
				components.match_state:reset_events()
				
				for event_index = 1,#events do
					local event = events[event_index]
					local qualifier = event.qualifier

					if qualifier == match_events.CLIENT_ADDED then
						local client_id = event.client_id
						local nickname = event.nickname
						local score = event.score
						print(os.date() .. " [LEVEL_DEATHMATCH] Add client, client_id=" .. client_id .. ", nickname=" .. nickname)
						components.match_state:add_client(client_id, nickname, score)

					elseif qualifier == match_events.PLAYER_CREATED then
						local client_id = event.client_id
						local x = event.x
						local y = event.y
						print(os.date() .. " [LEVEL_DEATHMATCH] Create player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)

						local z = y
						local position = vmath.vector3(x, y, z)
						level_utils:create_player(components, client_id, position)
						components.match_state:add_player(client_id, x, y)

					elseif qualifier == match_events.PLAYER_MOVED then
						local client_id = event.client_id
						local x = event.x
						local y = event.y

						print(os.date() .. " [LEVEL_DEATHMATCH] Move player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)
						level_utils:create_movement(components, client_id, x, y)

					elseif qualifier == match_events.PLAYER_KILLED then
						local client_id = event.client_id
						local killer_id = event.killer_id

						print(os.date() .. " [LEVEL_DEATHMATCH] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. killer_id)
						components.level_kills:add_kill(killer_id, client_id)

					elseif qualifier == match_events.PLAYER_DELETED then
						local client_id = event.client_id
						print(os.date() .. " [LEVEL_DEATHMATCH] Delete player, client_id=" .. client_id)
						level_utils:delete_player(components, client_id)
						components.match_state:delete_player(client_id)

					elseif qualifier == match_events.CLIENT_DELETED then
						local client_id = event.client_id
						print(os.date() .. " [LEVEL_DEATHMATCH] Delete client, client_id=" .. client_id)
						components.match_state:delete_client(client_id)

					end
				end
			end,
			player_moved = function(instance, components, event)
				local client_id = event.client_id
				local x = event.x
				local y = event.y

				print(os.date() .. " [LEVEL_DEATHMATCH] Player moved, client_id=" .. tostring(client_id))
				
				components.match_state:move_player(client_id, x, y)
				components.death_match:decrease_movements()

				local kill = components.level_kills:get_kill(client_id)
				if kill then
					local new_event = game_events:player_killed(kill.client_id, client_id)
					components.game_events:add_event(new_event)
				end
			end,
			player_killed = function(instance, components, event)
				local client_id = event.client_id
				local killer_id = event.killer_id
				print(os.date() .. " [LEVEL_DEATHMATCH] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. tostring(killer_id))
				level_utils:delete_player(components, client_id)
				components.match_state:kill_player(client_id, killer_id)

				components.level_kills:delete_kill(client_id)
			end,
			update = function(instance, dt, components)
				if components.death_match:is_simulation_state() then
					if components.death_match:are_movements_finished() then
						local step_events = components.match_state:get_events()
						local new_game_event = game_events:step_simulated(step_events)
						components.game_events:add_event(new_game_event)

						components.death_match:set_queueing_state()
					end
				end
			end
		}
	end
}

return level_deathmatch