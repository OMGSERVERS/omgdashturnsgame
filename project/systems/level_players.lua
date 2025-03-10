
local game_events = require("project.messages.game_events")

local level_movements
level_movements = {
	SPEED = 2,
	-- Methods
	create = function(self)
		local setup_player = function(components, client_id, flip, attack_angle)
			local player_collection_ids = components.level_state:get_player_collection_ids(client_id)
			if player_collection_ids then
				local player_skin_url = player_collection_ids["/skin"]
				local weapon_left_hand_url = player_collection_ids["/weapon_left_hand"]
				local weapon_right_hand_url = player_collection_ids["/weapon_right_hand"]
				sprite.set_hflip(player_skin_url, flip)
				if flip then
					msg.post(weapon_left_hand_url, "enable")
					msg.post(weapon_right_hand_url, "disable")
					if attack_angle then
						go.set_rotation(vmath.quat_rotation_z(attack_angle), weapon_left_hand_url)
					end
				else
					msg.post(weapon_left_hand_url, "disable")
					msg.post(weapon_right_hand_url, "enable")
					if attack_angle then
						go.set_rotation(vmath.quat_rotation_z(attack_angle), weapon_right_hand_url)
					end
				end
			end
		end
		
		return {
			qualifier = "level_movements",
			predicate = function(instance, components)
				return true
			end,
			player_created = function(instance, components, event)
				local client_id = event.client_id
				print(os.date() .. " [LEVEL_MOVEMENTS] Player created, client_id=" .. tostring(client_id))

				local nickname = components.match_state:get_nickname(client_id)
				local player_nickname_component_url = components.level_state:get_player_nickname_component_url(client_id)
				label.set_text(player_nickname_component_url, nickname)

				local player_skin_url = components.level_state:get_player_skin_url(client_id)
				go.animate(player_skin_url, "scale.x", go.PLAYBACK_LOOP_PINGPONG, 1.1, go.EASING_LINEAR, 1, 0)
				go.animate(player_skin_url, "scale.y", go.PLAYBACK_LOOP_PINGPONG, 1.1, go.EASING_LINEAR, 1, 0)
				
				setup_player(components, client_id, false)
			end,
			movement_created = function(instance, components, event)
				local client_id = event.client_id
				local x = event.x
				local y = event.y
				print(os.date() .. " [LEVEL_MOVEMENTS] Movement created, client_id=" .. tostring(client_id))

				local player_url = components.level_state:get_player_url(client_id)
				local player_position = go.get_position(player_url)
				-- local target_position = vmath.vector3(x, y, player_position.z)

				local flip = x < player_position.x
				local attack_angle = math.atan2(y - player_position.y, x - player_position.x) - math.pi * 0.5
				setup_player(components, client_id, flip, attack_angle)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return level_movements