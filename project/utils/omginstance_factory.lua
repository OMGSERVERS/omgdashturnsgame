local game_events = require("project.messages.game_events")
local omgplayer = require("omgservers.omgplayer.omgplayer")

local omginstance_factory
omginstance_factory = {
	create = function(self, components, configuration)
		local options = {
			tenant = configuration.tenant,
			project = configuration.project,
			stage = configuration.stage,
			event_handler = function(client_event)
				print(os.date() .. " [OMGINSTANCE FACTORY] Client event was received, event=" .. json.encode(client_event))

				local event_qualifier = client_event.qualifier
				local event_body = client_event.body

				if event_qualifier == omgplayer.constants.SIGNED_UP then
					local user_id = event_body.user_id 
					local password = event_body.password
					local new_game_event = game_events:signed_up(user_id, password)
					components.game_events:add_event(new_game_event)

				elseif event_qualifier == omgplayer.constants.SIGNED_IN then
					local client_id = event_body.client_id
					game_events:signed_in(client_id)
					local new_game_event = game_events:signed_in(client_id)
					components.game_events:add_event(new_game_event)

				elseif event_qualifier == omgplayer.constants.GREETED then
					local version_id = event_body.version_id
					local version_created = event_body.version_created
					local new_game_event = game_events:greeted(version_id, version_created)
					components.game_events:add_event(new_game_event)

				elseif event_qualifier == omgplayer.constants.ASSIGNED then
					local runtime_qualifier = event_body.runtime_qualifier
					local runtime_id = event_body.runtime_id
					local new_game_event = game_events:assigned(runtime_qualifier, runtime_id)
					components.game_events:add_event(new_game_event)

				elseif event_qualifier == omgplayer.constants.MESSAGE_RECEIVED then
					local decoded_message = json.decode(event_body.message)
					local new_game_event = game_events:server_message_received(decoded_message)
					components.game_events:add_event(new_game_event)

				elseif event_qualifier == omgplayer.constants.CONNECTION_DISPATCHED then
					local new_game_event = game_events:connection_dispatched()
					components.game_events:add_event(new_game_event)

				elseif event_qualifier == omgplayer.constants.PLAYER_FAILED then
					local reason = event_body.reason
					local new_game_event = game_events:client_failed(reason)
					components.game_events:add_event(new_game_event)

				end
			end,
			service_url = configuration.url,
			debug_logging = true,
			trace_logging = false,
		}

		local omginstance = omgplayer:create()
		omginstance:init(options)
		
		return omginstance
	end
}

return omginstance_factory