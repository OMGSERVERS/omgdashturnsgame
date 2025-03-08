local game_events = require("project.messages.game_events")

local player_manager
player_manager = {
	create = function(self)
		return {
			qualifier = "player_manager",
			predicate = function(instance, components)
				return true
			end,
			update = function(instance, dt, components)
				local movements_to_delete = {}
				local movements = components.level_state:get_movements()
				if movements then
					for client_id, movement in pairs(movements) do
						local get_player_url = components.level_state:get_player_url(client_id)

						local current_possition = go.get_position(get_player_url)
						local from_position = movement.from_position
						local to_position = movement.to_position

						local total_distance_sqr = vmath.length_sqr(to_position - from_position)
						local current_distance_sqr = vmath.length_sqr(current_possition - from_position)

						if current_distance_sqr >= total_distance_sqr then
							movements_to_delete[#movements_to_delete + 1] = client_id
						end
					end
				end

				for i = 1, #movements_to_delete do
					local client_id = movements_to_delete[i]
					components.level_state:delete_movement(client_id)
				end

				local events = components.game_events:get_events()
				for i = 1,#events do
					local game_event = events[i]
					local game_event_id = game_event.id

					if game_event_id == game_events.PLAYER_CREATED then
						local client_id = game_event.client_id
						print(os.date() .. " [PLAYER_MANAGER] Player created, client_id=" .. tostring(client_id))
						
						local nickname = components.match_state:get_nickname(client_id)
						local player_nickname_component_url = components.level_state:get_player_nickname_component_url(client_id)
						label.set_text(player_nickname_component_url, nickname)
					end
				end
			end
		}
	end
}

return player_manager