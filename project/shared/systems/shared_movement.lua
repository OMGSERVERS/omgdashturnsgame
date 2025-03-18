local game_events = require("project.message.game_events")

local shared_movement
shared_movement = {
	PLAYER_SPEED = 240,
	SERVER_SPEED = 480,
	-- Methods
	create = function(self)

		local get_simulation_speed = function(components)
			if not components.shared.bootstrap:is_server_mode() then
				return shared_movement.PLAYER_SPEED
			else
				return shared_movement.SERVER_SPEED
			end
		end
		
		return {
			qualifier = "shared_movement",
			predicate = function(instance, components)
				return true
			end,
			update = function(instance, dt, components)
				local client_ids = {}
				local movements = components.shared.movements:get_movements()
				for client_id, movement in pairs(movements) do
					local wrapped_player = components.shared.players:get_wrapped_player(client_id)
					if wrapped_player then
						local player_url = wrapped_player:get_player_url()

						local current_possition = go.get_position(player_url)
						local from_position = movement:get_from_position()
						local to_position = movement:get_to_position()

						local total_distance_sqr = movement:get_distance_sqr()
						local current_distance_sqr = vmath.length_sqr(current_possition - from_position)

						if current_distance_sqr >= total_distance_sqr then
							print(os.date() .. " [SHARED_MOVEMENT] Player moved, client_id=" .. tostring(client_id))

							-- Set final position
							go.set_position(to_position, player_url)

							local new_game_event = game_events:player_moved(client_id, current_possition.x, current_possition.y)
							components.shared.events:add_event(new_game_event)

							client_ids[#client_ids + 1] = client_id
						else
							local direction = vmath.normalize(to_position - from_position)
							local simulation_speed = get_simulation_speed(components)
							local new_position = current_possition + direction * (simulation_speed * dt)
							go.set_position(new_position, player_url)
						end
					end
				end

				components.shared.movements:delete_by_client_ids(client_ids)
			end
		}
	end
}

return shared_movement