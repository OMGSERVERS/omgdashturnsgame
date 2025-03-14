local defold_match_player = require("project.defold.match_player.match_player")
local movement_factory = require("project.utils.movement_factory")
local match_requests = require("project.messages.match_requests")
local game_events = require("project.messages.game_events")
local match_events = require("project.messages.match_events")

local death_match
death_match = {
	create = function(self)

		local create_player = function(components, client_id, position)
			local player_factory_url = components.level_state:get_player_factory_url()
			local player_collection_ids = collectionfactory.create(player_factory_url, position)
			pprint(player_collection_ids)

			components.level_state:add_player(client_id, player_collection_ids)

			local new_game_event = game_events:player_created(client_id)
			components.game_events:add_event(new_game_event)

			local player_url = components.level_state:get_player_url(client_id)
			-- just play events from the server in client mode
			local disable_collisions = components.entrypoint_state:is_client_mode()
			defold_match_player:setup_player(player_url, client_id, disable_collisions)
		end

		local delete_player = function(components, client_id)
			local player_collection_ids = components.level_state:get_player_collection_ids(client_id)
			if player_collection_ids then
				print(os.date() .. " [DEATH_MATCH] Delete player, client_id=" .. client_id)
				pprint(player_collection_ids)
				for key, go_id in pairs(player_collection_ids) do
					go.delete(go_id)
				end
				components.level_state:delete_player(client_id)
			else
				print(os.date() .. " [DEATH_MATCH] Player was not found to delete, client_id=" .. client_id)
			end
		end

		local create_movement = function(components, client_id, x, y)
			local player_url = components.level_state:get_player_url(client_id)
			local from_position = go.get_position(player_url)

			local z = y
			local to_position = vmath.vector3(x, y, z)

			local result = physics.raycast(from_position, to_position, { hash("level") })
			if result then
				local hit_position = result.position
				hit_position.z = hit_position.y
				local distance = vmath.length(hit_position - from_position)
				if distance < 16 then
					to_position = from_position
				else
					to_position = hit_position
				end
			end

			local movement = movement_factory:create(client_id, from_position, to_position)
			components.level_movements:add_movement(movement)

			local new_game_event = game_events:movement_created(client_id, x, y)
			components.game_events:add_event(new_game_event)
		end
		
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
					print(os.date() .. " [DEATH_MATCH] Step is over, but match is still in simulation, step=" .. step_index)
				else
					print(os.date() .. " [DEATH_MATCH] Step is over, step=" .. step_index)
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

						print(os.date() .. " [DEATH_MATCH] Add client, client_id=" .. client_id .. ", nickname=" .. nickname)
						components.match_state:add_client(client_id, nickname, score)

					elseif qualifier == match_requests.SPAWN_PLAYER then
						local client_id = request.client_id
						print(os.date() .. " [DEATH_MATCH] Spawn player, client_id=" .. client_id)

						local spawn_position = components.level_state:get_random_spawn_position()
						if spawn_position then
							create_player(components, client_id, spawn_position)
							components.match_state:add_player(client_id, spawn_position.x, spawn_position.y)
						else
							print(os.date() .. " [DEATH_MATCH] Level bounds is not set to spawn player, client_id=" .. client_id)
						end

					elseif qualifier == match_requests.MOVE_PLAYER then
						local client_id = request.client_id
						local x = request.x
						local y = request.y

						print(os.date() .. " [DEATH_MATCH] Move player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)
						if not components.level_state:get_movement(client_id) then
							components.death_match:increase_movements()
						end
						create_movement(components, client_id, x, y)

					elseif qualifier == match_requests.DELETE_PLAYER then
						local client_id = request.client_id

						print(os.date() .. " [DEATH_MATCH] Delete player, client_id=" .. client_id)
						delete_player(components, client_id)
						components.match_state:delete_player(client_id)

					elseif qualifier == match_requests.DELETE_CLIENT then
						local client_id = request.client_id
						print(os.date() .. " [DEATH_MATCH] Delete client, client_id=" .. client_id)
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
					create_player(components, client_id, position)
				end
			end,
			events_received = function(instance, components, event)
				local events = event.events
				print(os.date() .. " [DEATH_MATCH] Events were received, total=" .. #events)
				components.match_state:reset_events()
				
				for event_index = 1,#events do
					local event = events[event_index]
					local qualifier = event.qualifier

					if qualifier == match_events.CLIENT_ADDED then
						local client_id = event.client_id
						local nickname = event.nickname
						local score = event.score
						print(os.date() .. " [DEATH_MATCH] Add client, client_id=" .. client_id .. ", nickname=" .. nickname)
						components.match_state:add_client(client_id, nickname, score)

					elseif qualifier == match_events.PLAYER_CREATED then
						local client_id = event.client_id
						local x = event.x
						local y = event.y
						print(os.date() .. " [DEATH_MATCH] Create player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)

						local z = y
						local position = vmath.vector3(x, y, z)
						create_player(components, client_id, position)
						components.match_state:add_player(client_id, x, y)

					elseif qualifier == match_events.PLAYER_MOVED then
						local client_id = event.client_id
						local x = event.x
						local y = event.y

						print(os.date() .. " [DEATH_MATCH] Move player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)
						create_movement(components, client_id, x, y)

					elseif qualifier == match_events.PLAYER_KILLED then
						local client_id = event.client_id
						local killer_id = event.killer_id

						print(os.date() .. " [DEATH_MATCH] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. killer_id)
						components.level_state:add_kill(client_id, killer_id)

					elseif qualifier == match_events.PLAYER_DELETED then
						local client_id = event.client_id
						print(os.date() .. " [DEATH_MATCH] Delete player, client_id=" .. client_id)
						delete_player(components, client_id)
						components.match_state:delete_player(client_id)

					elseif qualifier == match_events.CLIENT_DELETED then
						local client_id = event.client_id
						print(os.date() .. " [DEATH_MATCH] Delete client, client_id=" .. client_id)
						components.match_state:delete_client(client_id)

					end
				end
			end,
			player_moved = function(instance, components, event)
				local client_id = event.client_id
				local x = event.x
				local y = event.y

				print(os.date() .. " [DEATH_MATCH] Player moved, client_id=" .. tostring(client_id))
				
				components.match_state:move_player(client_id, x, y)
				components.death_match:decrease_movements()

				local kill = components.level_state:get_kill(client_id)
				if kill then
					local new_event = game_events:player_killed(kill.client_id, client_id)
					components.game_events:add_event(new_event)
				end
			end,
			player_killed = function(instance, components, event)
				local client_id = event.client_id
				local killer_id = event.killer_id
				print(os.date() .. " [DEATH_MATCH] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. tostring(killer_id))
				delete_player(components, client_id)
				components.match_state:kill_player(client_id, killer_id)

				components.level_state:delete_kill(client_id)
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

return death_match