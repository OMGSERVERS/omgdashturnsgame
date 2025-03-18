local match_requests = require("project.message.match_requests")
local game_events = require("project.message.game_events")
local level_module = require("project.module.level_module")

local server_level
server_level = {
	create = function(self)
		return {
			qualifier = "server_level",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_server_mode() then
					return
				end

				if not components.server.state:is_match_runtime() then
					return
				end
				
				return true
			end,
			state_initialized = function(instance, components, event)
				local level_qualifier = components.shared.state:get_level_qualifier()
				print(os.date() .. " [SERVER_LEVEL] State initialized, creating level, level_qualifier=" .. tostring(level_qualifier))
				level_module:create_level(components, level_qualifier)
			end,
			collision_detected = function(instance, components, event)
				local a_url = event.a_url
				local b_url = event.b_url

				local a_client_id = components.shared.players:get_client_id(a_url)
				local b_client_id = components.shared.players:get_client_id(b_url)

				if a_client_id and b_client_id then
					print(os.date() .. " [LEVEL_MOVEMENTS] Collission detected, a_client_id=" .. tostring(a_client_id) .. ", b_client_id=" .. tostring(b_client_id))

					local a_movement = components.shared.movements:get_movement(a_client_id)
					local a_position = event.a_position

					local b_movement = components.shared.movements:get_movement(b_client_id)
					local b_position = event.b_position

					if a_movement and not b_movement then
						-- A is winner
						local new_event = game_events:player_killed(b_client_id, a_client_id)
						components.shared.events:add_event(new_event)
					elseif not a_movement and b_movement then
						-- B is winner
						local new_event = game_events:player_killed(a_client_id, b_client_id)
						components.shared.events:add_event(new_event)
					elseif a_movement and b_movement then
						local a_to_position = a_movement:get_to_position()
						local b_to_position = b_movement:get_to_position()

						local a_distance = vmath.length(a_to_position - a_position)
						local b_distance = vmath.length(b_to_position - b_position)

						if a_distance < b_distance then
							-- A is winner
							local new_event = game_events:player_killed(b_client_id, a_client_id)
							components.shared.events:add_event(new_event)
						else
							-- B is winner
							local new_event = game_events:player_killed(a_client_id, b_client_id)
							components.shared.events:add_event(new_event)
						end
					end

					if a_movement then
						local a_from_position = a_movement:get_from_position()

						if vmath.length(a_position - a_from_position) > 32 then
							pprint(a_position)
							a_movement:set_to_position(a_position)
						end
					end

					if b_movement then
						local b_from_position = b_movement:get_from_position()
						if vmath.length(b_position - b_from_position) > 32 then
							pprint(b_position)
							b_movement:set_to_position(b_position)
						end
					end
				end
			end,
			step_over = function(instance, components, event)
				local step_index = event.step_index
				print(os.date() .. " [SERVER_LEVEL] Step is over, step=" .. step_index)

				components.shared.state:set_step(step_index)
				components.shared.state:reset_events()

				local pulled_requests = components.server.match:pull_requests()
				for request_index = 1,#pulled_requests do
					local request = pulled_requests[request_index]
					local qualifier = request.qualifier

					if qualifier == match_requests.ADD_CLIENT then
						local client_id = request.client_id
						local nickname = request.nickname
						local score = request.score

						print(os.date() .. " [SERVER_LEVEL] Add client, client_id=" .. client_id .. ", nickname=" .. nickname)
						components.shared.state:add_client(client_id, nickname, score)

					elseif qualifier == match_requests.SPAWN_PLAYER then
						local client_id = request.client_id
						print(os.date() .. " [SERVER_LEVEL] Spawn player, client_id=" .. client_id)

						local spawn_position = components.shared.level:get_random_spawn_position()
						if spawn_position then
							local x = spawn_position.x
							local y = spawn_position.y
							level_module:create_player(components, client_id, x, y)
							components.shared.state:add_player(client_id, x, y)
						else
							print(os.date() .. " [SERVER_LEVEL] Level bounds is not set to spawn player, client_id=" .. client_id)
						end

					elseif qualifier == match_requests.MOVE_PLAYER then
						local client_id = request.client_id
						local x = request.x
						local y = request.y

						print(os.date() .. " [SERVER_LEVEL] Move player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)
						level_module:create_movement(components, client_id, x, y)

					elseif qualifier == match_requests.DELETE_PLAYER then
						local client_id = request.client_id

						print(os.date() .. " [SERVER_LEVEL] Delete player, client_id=" .. client_id)
						level_module:delete_player(components, client_id)
						components.shared.state:delete_player(client_id)

					elseif qualifier == match_requests.DELETE_CLIENT then
						local client_id = request.client_id
						print(os.date() .. " [SERVER_LEVEL] Delete client, client_id=" .. client_id)
						components.shared.state:delete_client(client_id)
					end
				end
			end,
			player_moved = function(instance, components, event)
				local client_id = event.client_id
				local x = event.x
				local y = event.y

				print(os.date() .. " [SERVER_LEVEL] Player moved, client_id=" .. tostring(client_id))
				
				components.shared.state:move_player(client_id, x, y)
			end,
			player_killed = function(instance, components, event)
				local client_id = event.client_id
				local killer_id = event.killer_id
				print(os.date() .. " [SERVER_LEVEL] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. tostring(killer_id))
				level_module:delete_player(components, client_id)
				components.shared.state:kill_player(client_id, killer_id)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return server_level