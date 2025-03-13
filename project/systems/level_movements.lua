
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

				local a_client_id = components.level_state:get_client_id(a_url)
				local b_client_id = components.level_state:get_client_id(b_url)

				if a_client_id and b_client_id then
					print(os.date() .. " [LEVEL_MOVEMENTS] Collission detected, a_client_id=" .. tostring(a_client_id) .. ", b_client_id=" .. tostring(b_client_id))

					local a_movement = components.level_state:get_movement(a_client_id)
					local a_position = event.a_position
					local b_movement = components.level_state:get_movement(b_client_id)
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
						local a_distance = vmath.length(a_movement.to_position - a_position)
						local b_distance = vmath.length(b_movement.to_position - b_position)

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
						if vmath.length(event.a_position - a_movement.from_position) > 32 then
							a_movement.to_position = a_position
						end
					end
					
					
					if b_movement then
						if vmath.length(event.b_position - b_movement.from_position) > 32 then
							b_movement.to_position = b_position
						end
					end
				end
			end,
			update = function(instance, dt, components)
				local movements_to_delete = {}
				local movements = components.level_state:get_movements()
				if movements then
					for client_id, movement in pairs(movements) do
						local player_url = components.level_state:get_player_url(client_id)

						local current_possition = go.get_position(player_url)
						local from_position = movement.from_position
						local to_position = movement.to_position

						local total_distance_sqr = vmath.length_sqr(to_position - from_position)
						local current_distance_sqr = vmath.length_sqr(current_possition - from_position)

						if current_distance_sqr >= total_distance_sqr then
							print(os.date() .. " [LEVEL_MOVEMENTS] Player moved, client_id=" .. tostring(client_id))

							-- set final position
							go.set_position(to_position, player_url)
							
							local new_game_event = game_events:player_moved(client_id, current_possition.x, current_possition.y)
							components.game_events:add_event(new_game_event)

							movements_to_delete[#movements_to_delete + 1] = client_id
						else
							local direction = vmath.normalize(to_position - from_position)
							local new_position = current_possition + direction * (level_movements.SPEED * dt)
							go.set_position(new_position, player_url)
						end
					end
				end

				for _, client_id in ipairs(movements_to_delete) do
					components.level_state:delete_movement(client_id)
				end
			end
		}
	end
}

return level_movements