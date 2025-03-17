local level_module = require("project.module.level_module")

local client_skin
client_skin = {
	-- Methods
	create = function(self)
		local disable_weapons = function(components, client_id)
			local wrapped_player = components.shared.players:get_wrapped_player(client_id)
			if wrapped_player then
				local weapon_left_hand_url = wrapped_player:get_weapon_left_hand_url()
				local weapon_right_hand_url = wrapped_player:get_weapon_right_hand_url()
				msg.post(weapon_left_hand_url, "disable")
				msg.post(weapon_right_hand_url, "disable")
			end
		end

		local play_death_animation = function(components, client_id, callback)
			local wrapped_player = components.shared.players:get_wrapped_player(client_id)
			if wrapped_player then
				disable_weapons(components, client_id)
				
				local player_nickname_component_url = wrapped_player:get_player_nickname_component_url(client_id)
				msg.post(player_nickname_component_url, "disable")
				
				local player_url = wrapped_player:get_player_url()
				local player_position = go.get_position(player_url)
				go.animate(player_url, "position.y", go.PLAYBACK_ONCE_FORWARD, player_position.y + 16, go.EASING_LINEAR, 0.5)
				
				local player_skin_sprite_component_url = wrapped_player:get_player_skin_sprite_component_url()
				go.animate(player_skin_sprite_component_url, "tint.w", go.PLAYBACK_ONCE_FORWARD, 0, go.EASING_LINEAR, 0.5, 0, callback)
			end
		end

		local setup_skin = function(components, client_id, flip, attack_angle)
			local wrapped_player = components.shared.players:get_wrapped_player(client_id)
			if wrapped_player then
				local player_skin_url = wrapped_player:get_player_skin_url()
				local weapon_left_hand_url = wrapped_player:get_weapon_left_hand_url()
				local weapon_right_hand_url = wrapped_player:get_weapon_right_hand_url()
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
			qualifier = "level_players",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				return true
			end,
			player_created = function(instance, components, event)
				local client_id = event.client_id
				local wrapped_player = components.shared.players:get_wrapped_player(client_id)
				if wrapped_player then
					print(os.date() .. " [CLIENT_SKIN] Player created, client_id=" .. tostring(client_id))

					local nickname = components.shared.state:get_nickname(client_id)
					local player_nickname_component_url = wrapped_player:get_player_nickname_component_url(client_id)
					label.set_text(player_nickname_component_url, nickname)

					local player_skin_url = wrapped_player:get_player_skin_url(client_id)
					go.animate(player_skin_url, "scale.x", go.PLAYBACK_LOOP_PINGPONG, 1.1, go.EASING_LINEAR, 1, 0)
					go.animate(player_skin_url, "scale.y", go.PLAYBACK_LOOP_PINGPONG, 1.1, go.EASING_LINEAR, 1, 0)

					local player_url = wrapped_player:get_player_url()
					local player_position = go.get_position(player_url)
					local z = player_position.y
					local new_position = vmath.vector3(player_position.x, player_position.y, z)
					go.set_position(new_position, player_url)
					
					setup_skin(components, client_id, false)
				end
			end,
			movement_created = function(instance, components, event)
				local client_id = event.client_id
				local x = event.x
				local y = event.y
				local wrapped_player = components.shared.players:get_wrapped_player(client_id)
				if wrapped_player then
					print(os.date() .. " [CLIENT_SKIN] Movement created, client_id=" .. tostring(client_id))
					
					local player_url = wrapped_player:get_player_url()
					local player_position = go.get_position(player_url)
					-- local target_position = vmath.vector3(x, y, player_position.z)

					local flip = x < player_position.x
					local attack_angle = math.atan2(y - player_position.y, x - player_position.x) - math.pi * 0.5
					setup_skin(components, client_id, flip, attack_angle)
				end
			end,
			player_killed = function(instance, components, event)
				local client_id = event.client_id
				local killer_id = event.killer_id
				print(os.date() .. " [CLIENT_SKIN] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. tostring(killer_id))

				play_death_animation(components, client_id, function()
					level_module:delete_player(components, client_id)
				end)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return client_skin