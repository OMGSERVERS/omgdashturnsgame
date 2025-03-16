local defold_match_gui = require("project.defold.match_gui.match_gui")
local level_module = require("project.module.level_module")
local match_events = require("project.message.match_events")
local game_events = require("project.message.game_events")

local client_level_system
client_level_system = {
	-- Methods
	create = function(self)
		return {
			qualifier = "client_level_system",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				return true
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
					level_module:create_player(components, client_id, position)
				end
			end,
			events_received = function(instance, components, event)
				local events = event.events
				print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Events were received, total=" .. #events)
				components.match_state:reset_events()

				local match_gui_url = components.screen_state:get_match_gui_url()
				if match_gui_url then
					local step_interval = components.match_state.get_settings().step_interval
					defold_match_gui:reset_progress_bar(match_gui_url, step_interval)
				end
				
				for event_index = 1,#events do
					local event = events[event_index]
					local qualifier = event.qualifier

					if qualifier == match_events.CLIENT_ADDED then
						local client_id = event.client_id
						local nickname = event.nickname
						local score = event.score
						print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Add client, client_id=" .. client_id .. ", nickname=" .. nickname)
						components.match_state:add_client(client_id, nickname, score)

					elseif qualifier == match_events.PLAYER_CREATED then
						local client_id = event.client_id
						local x = event.x
						local y = event.y
						print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Create player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)

						local z = y
						local position = vmath.vector3(x, y, z)
						level_module:create_player(components, client_id, position)
						components.match_state:add_player(client_id, x, y)

					elseif qualifier == match_events.PLAYER_MOVED then
						local client_id = event.client_id
						local x = event.x
						local y = event.y

						print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Move player, client_id=" .. client_id .. ", x=" .. x .. ", y=" .. y)
						level_module:create_movement(components, client_id, x, y)

					elseif qualifier == match_events.PLAYER_KILLED then
						local client_id = event.client_id
						local killer_id = event.killer_id

						print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. killer_id)
						components.level_kills:add_kill(killer_id, client_id)

					elseif qualifier == match_events.PLAYER_DELETED then
						local client_id = event.client_id
						print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Delete player, client_id=" .. client_id)
						level_module:delete_player(components, client_id)
						components.match_state:delete_player(client_id)

					elseif qualifier == match_events.CLIENT_DELETED then
						local client_id = event.client_id
						print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Delete client, client_id=" .. client_id)
						components.match_state:delete_client(client_id)

					end
				end
			end,
			player_moved = function(instance, components, event)
				local client_id = event.client_id
				local x = event.x
				local y = event.y

				print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Player moved, client_id=" .. tostring(client_id))

				components.match_state:move_player(client_id, x, y)

				local kill = components.level_kills:get_kill(client_id)
				if kill then
					local new_event = game_events:player_killed(kill.client_id, client_id)
					components.game_events:add_event(new_event)
				end
			end,
			player_killed = function(instance, components, event)
				local client_id = event.client_id
				local killer_id = event.killer_id
				print(os.date() .. " [CLIENT_LEVEL_SYSTEM] Player killed, client_id=" .. tostring(client_id) .. ", killer_id=" .. tostring(killer_id))
				level_module:delete_player(components, client_id)
				components.match_state:kill_player(client_id, killer_id)

				components.level_kills:delete_kill(killer_id)
			end,
			match_screen_created = function(instance, components, event)
				local level_qualifier = components.match_state:get_level_qualifier()
				print(os.date() .. " [LEVEL_MANAGER] Match screen created, creating level, level_qualifier=" .. level_qualifier)
				level_module:create_level(components, level_qualifier)
			end,
			leaving_screen_created = function(instance, components, event)
				level_module:delete_level(components)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return client_level_system