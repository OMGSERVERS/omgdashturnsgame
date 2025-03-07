local match_requests = require("project.messages.match_requests")
local server_events = require("project.messages.server_events")
local client_events = require("project.messages.client_events")
local match_events = require("project.messages.match_events")

local death_match
death_match = {
	create = function(self)

		local create_player = function(components, client_id, position)
			local player_factory_url = components.level_state:get_player_factory_url()
			local player_collection_ids = collectionfactory.create(player_factory_url, position)
			pprint(player_collection_ids)

			components.level_state:add_player(client_id, player_collection_ids)

			local nickname = components.match_state:get_nickname(client_id)
			local player_nickname_component_url = components.level_state:get_player_nickname_component_url(client_id)
			label.set_text(player_nickname_component_url, nickname)
		end

		local delete_player = function(components, client_id)
			local player_collection_ids = components.level_state:get_player_collection_ids(client_id)
			if player_collection_ids then
				print(os.date() .. " [DEATH_MATCH] Delete player, client_id=" .. client_id)
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

			local movement = {
				from_position = from_position,
				to_position = to_position,
			}
			components.level_state:add_movement(client_id, movement)
		end
		
		return {
			qualifier = "death_match",
			update = function(instance, dt, components)
				if not components.match_state:is_death_match() then
					return
				end

				if components.death_match:is_simulation_state() then
					if #components.level_state:get_movements() == 0 then
						local match_events = components.match_state:get_events()
						local new_game_event = server_events:step_simulated(match_events)
						components.game_events:add_event(new_game_event)

						components.death_match:set_queueing_state()
					end
				end

				local game_events = components.game_events:get_events()
				for i = 1,#game_events do
					local game_event = game_events[i]
					local game_event_id = game_event.id

					if game_event_id == server_events.STEP_OVER then
						local step_index = game_event.step_index
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

								local level_bounds = components.level_state:get_level_bounds()
								if level_bounds then
									local x = level_bounds.x
									local y = level_bounds.y
									local w = level_bounds.w
									local h = level_bounds.h
									local spawn_x = math.random(x, x + w)
									local spawn_y = math.random(y, y + h)

									local z = y
									local position = vmath.vector3(spawn_x, spawn_y, z)

									create_player(components, client_id, position)
									components.match_state:add_player(client_id, spawn_x, spawn_y)
								else
									print(os.date() .. " [DEATH_MATCH] Level bounds is not set to spawn player, client_id=" .. client_id)
								end

							elseif qualifier == match_requests.MOVE_PLAYER then
								local client_id = request.client_id
								local x = request.x
								local y = request.y

								print(os.date() .. " [DEATH_MATCH] Move player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)
								create_movement(components, client_id, x, y)

							elseif qualifier == match_requests.DELETE_PLAYER then
								local client_id = request.client_id

								print(os.date() .. " [DEATH_MATCH] Delete player, client_id=" .. client_id)
								delete_player(client_id)
								components.match_state:delete_player(client_id)

							elseif qualifier == match_requests.DELETE_CLIENT then
								local client_id = request.client_id
								print(os.date() .. " [DEATH_MATCH] Delete client, client_id=" .. client_id)
								components.match_state:delete_client(client_id)
							end
						end

					elseif game_event_id == client_events.LEVEL_CREATED then
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
						
					elseif game_event_id == client_events.EVENTS_RECEIVED then
						local events = game_event.events
						print(os.date() .. " [DEATH_MATCH] Events were received, total=" .. #events)

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

								-- TBD

							elseif qualifier == match_events.PLAYER_DELETED then
								local client_id = event.client_id
								print(os.date() .. " [DEATH_MATCH] Delete player, client_id=" .. client_id)
								delete_player(client_id)
								components.match_state:delete_player(client_id)
								
							elseif qualifier == match_events.CLIENT_DELETED then
								local client_id = event.client_id
								print(os.date() .. " [DEATH_MATCH] Delete client, client_id=" .. client_id)
								components.match_state:delete_client(client_id)
								
							end
						end
					end
				end
			end
		}
	end
}

return death_match