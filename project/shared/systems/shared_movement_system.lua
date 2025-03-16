
local game_events = require("project.message.game_events")

local shared_movement_system
shared_movement_system = {
	SPEED = 160,
	-- Methods
	create = function(self)
		return {
			qualifier = "shared_movement_system",
			predicate = function(instance, components)
				return true
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
							print(os.date() .. " [SHARED_MOVEMENT_SYSTEM] Player moved, client_id=" .. tostring(client_id))

							-- set final position
							go.set_position(to_position, player_url)

							local new_game_event = game_events:player_moved(client_id, current_possition.x, current_possition.y)
							components.game_events:add_event(new_game_event)

							client_ids[#client_ids + 1] = client_id
						else
							local direction = vmath.normalize(to_position - from_position)
							local new_position = current_possition + direction * (shared_movement_system.SPEED * dt)
							go.set_position(new_position, player_url)
						end
					end
				end

				components.level_movements:delete_by_client_ids(client_ids)
			end
		}
	end
}

return shared_movement_system