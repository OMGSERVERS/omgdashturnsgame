local game_events = require("project.message.game_events")
local omgplayer = require("omgservers.omgplayer.omgplayer")

local client_screen
client_screen = {
	AUTH_SCREEN_FACTORY = "/screen_factory#auth_screen",
	LOBBY_SCREEN_FACTORY = "/screen_factory#lobby_screen",
	OPS_SCREEN_FACTORY = "/screen_factory#ops_screen",
	JOINING_SCREEN_FACTORY = "/screen_factory#joining_screen",
	MATCH_SCREEN_FACTORY = "/screen_factory#match_screen",
	LEAVING_SCREEN_FACTORY = "/screen_factory#leaving_screen",
	-- Methods
	create = function(self)
		local create_screen = function(components, factory)
			local prev_screen_ids = components.client.screen:get_collection_ids()
			if prev_screen_ids then
				for key, screen_go_id in pairs(prev_screen_ids) do
					go.delete(screen_go_id)
				end
			end

			local new_screen_ids = collectionfactory.create(factory)
			pprint(new_screen_ids)

			return new_screen_ids
		end

		local create_auth_screen = function(components)
			local new_screen_ids = create_screen(components, client_screen.AUTH_SCREEN_FACTORY)
			components.client.screen:set_auth_screen(new_screen_ids)

			local new_event = game_events:auth_screen_created()
			components.shared.events:add_event(new_event)
		end

		local create_lobby_screen = function(components)
			local new_screen_ids = create_screen(components, client_screen.LOBBY_SCREEN_FACTORY)
			components.client.screen:set_lobby_screen(new_screen_ids)

			local new_event = game_events:lobby_screen_created()
			components.shared.events:add_event(new_event)
		end
		
		return {
			qualifier = "screen_manager",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end
				
				return true
			end,
			client_started = function(instance, components, event)
				print(os.date() .. " [CLIENT_SCREEN] Game client started")
				create_auth_screen(components)
			end,
			client_failed = function(instance, components, event)
				local reason = event.reason
				print(os.date() .. " [CLIENT_SCREEN] Client failed, reason=" ..reason)

				local new_screen_ids = create_screen(components, client_screen.OPS_SCREEN_FACTORY)
				components.client.screen:set_ops_screen(new_screen_ids)

				components.screen.ops:set_state_text(reason)

				local new_event = game_events:ops_screen_created()
				components.shared.events:add_event(new_event)
			end,
			reset_pressed = function(instance, components, event)
				print(os.date() .. " [CLIENT_SCREEN] Reset button is pressed")
				components.client.state:reset_state()
				create_auth_screen(components)
			end,
			profile_updated = function(instance, components, event)
				print(os.date() .. " [CLIENT_SCREEN] Profile updated")
				if components.client.state:is_getting_profile_state() then
					create_lobby_screen(components)
				end
			end,
			join_pressed = function(instance, components, event)
				local nickname = event.nickname
				print(os.date() .. " [CLIENT_SCREEN] Join button is pressed, nickname=" .. nickname)

				local new_screen_ids = create_screen(components, client_screen.JOINING_SCREEN_FACTORY)
				components.client.screen:set_joining_screen(new_screen_ids)
				
				local new_event = game_events:joining_screen_created()
				components.shared.events:add_event(new_event)
			end,
			assigned = function(instance, components, event)
				local runtime_qualifier = event.runtime_qualifier
				print(os.date() .. " [CLIENT_SCREEN] Assigned, runtime_qualifier=" .. tostring(runtime_qualifier))

				if runtime_qualifier == omgplayer.constants.LOBBY then
					create_lobby_screen(components)
				end
			end,
			state_received = function(instance, components, event)
				print(os.date() .. " [CLIENT_SCREEN] State received")

				if components.client.state:is_getting_state_state() then
					local new_screen_ids = create_screen(components, client_screen.MATCH_SCREEN_FACTORY)
					components.client.screen:set_match_screen(new_screen_ids)

					local new_event = game_events:match_screen_created()
					components.shared.events:add_event(new_event)
				else
					print(os.date() .. " [CLIENT_SCREEN] State was received but client is not getting state, skip it")
				end
			end,
			leave_pressed = function(instance, components, event)
				print(os.date() .. " [CLIENT_SCREEN] Leave button is pressed")

				local new_screen_ids = create_screen(components, client_screen.LEAVING_SCREEN_FACTORY)
				components.client.screen:set_leaving_screen(new_screen_ids)

				local new_event = game_events:leaving_screen_created()
				components.shared.events:add_event(new_event)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return client_screen