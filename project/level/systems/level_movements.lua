
local game_events = require("project.messages.game_events")

local level_movements
level_movements = {
	SPEED = 160,
	-- Methods
	create = function(self)
		return {
			qualifier = "level_movements",
			predicate = function(instance, components)
				return true
			end,
			collision_detected = function(instance, components, event)
				local a_url = event.a_url
				local b_url = event.b_url

				local a_client_id = components.level_players:get_client_id(a_url)
				local b_client_id = components.level_players:get_client_id(b_url)

				if a_client_id and b_client_id then
					print(os.date() .. " [LEVEL_MOVEMENTS] Collission detected, a_client_id=" .. tostring(a_client_id) .. ", b_client_id=" .. tostring(b_client_id))

					local a_movement = components.level_movements:get_movement(a_client_id)
					local a_position = event.a_position

					local b_movement = components.level_movements:get_movement(b_client_id)
					local b_position = event.b_position
					
					if a_movement and not b_movement then
						-- A is winner
						local new_event = game_events:player_killed(b_client_id, a_client_id)
						components.game_events:add_event(new_event)
					elseif not a_movement and b_movement then
						-- B is winner
						local new_event = game_events:player_killed(a_client_id, b_client_id)
						components.game_events:add_event(new_event)
					elseif a_movement and b_movement then
						local a_to_position = a_movement:get_to_position()
						local b_to_position = b_movement:get_to_position()
						
						local a_distance = vmath.length(a_to_position - a_position)
						local b_distance = vmath.length(b_to_position - b_position)

						if a_distance < b_distance then
							-- A is winner
							local new_event = game_events:player_killed(b_client_id, a_client_id)
							components.game_events:add_event(new_event)
						else
							-- B is winner
							local new_event = game_events:player_killed(a_client_id, b_client_id)
							components.game_events:add_event(new_event)
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
			update = function(instance, dt, components)
				local client_ids = {}
				local movements = components.level_movements:get_movements()
				for client_id, movement in pairs(movements) do
					local wrapped_player = components.level_players:get_wrapped_player(client_id)
					if wrapped_player then
						local player_url = wrapped_player:get_player_url()

						local current_possition = go.get_position(player_url)
						local from_position = movement:get_from_position()
						local to_position = movement:get_to_position()

						local total_distance_sqr = movement:get_distance_sqr()
						local current_distance_sqr = vmath.length_sqr(current_possition - from_position)

						if current_distance_sqr >= total_distance_sqr then
							print(os.date() .. " [LEVEL_MOVEMENTS] Player moved, client_id=" .. tostring(client_id))

							-- set final position
							go.set_position(to_position, player_url)

							local new_game_event = game_events:player_moved(client_id, current_possition.x, current_possition.y)
							components.game_events:add_event(new_game_event)

							client_ids[#client_ids + 1] = client_id
						else
							local direction = vmath.normalize(to_position - from_position)
							local new_position = current_possition + direction * (level_movements.SPEED * dt)
							go.set_position(new_position, player_url)
						end
					end
				end

				components.level_movements:delete_by_client_ids(client_ids)
			end
		}
	end
}

return level_movements