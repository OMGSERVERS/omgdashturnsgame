local server_messages = require("project.message.server_messages")
local profile_wrapper = require("project.module.profile_wrapper")
local game_messages = require("project.message.game_messages")
local omgruntime = require("omgservers.omgruntime.omgruntime")

local DEFAULT_GAME_MODE = "death-match"

local server_lobby
server_lobby = {
	create = function(self)

		local respond_client = function(current_omgruntime, client_id, message)
			current_omgruntime:respond_client(client_id, json.encode(message))
		end
		
		return {
			qualifier = "server_lobby",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_server_mode() then
					return
				end

				if not components.server.state:is_lobby_runtime() then
					return
				end
				
				return true
			end,
			command_received = function(instance, components, event)
				local command_qualifier = event.command_qualifier
				local command_body = event.command_body

				local current_omgruntime = components.server.state:get_omgruntime()

				if command_qualifier == omgruntime.constants.INIT_RUNTIME then
					print(os.date() .. " [SERVER_LOBBY] Init runtime")
					local version_config = command_body.runtime_config.version_config
					components.server.lobby:set_config(version_config)

				elseif command_qualifier == omgruntime.constants.ADD_CLIENT then
					local client_id = command_body.client_id
					local profile = command_body.profile
					print(os.date() .. " [SERVER_LOBBY] Add client, client_id=" .. tostring(client_id))

					if profile.version then
						local wrapped_profile = profile_wrapper:wrap(profile)
						components.server.lobby:add_profile(client_id, wrapped_profile)
					else
						local new_player_id = components.server.lobby:get_next_id()
						local player_nickname = "Player" .. new_player_id
						local wrapped_profile = profile_wrapper:create(player_nickname)
						components.server.lobby:add_profile(client_id, wrapped_profile)

						current_omgruntime:set_profile(client_id, wrapped_profile.profile)
					end

				elseif command_qualifier == omgruntime.constants.DELETE_CLIENT then
					local client_id = command_body.client_id
					print(os.date() .. " [SERVER_LOBBY] Delete client, client_id=" .. tostring(client_id))
					components.server.lobby:delete_profile(client_id)

				elseif command_qualifier == omgruntime.constants.HANDLE_MESSAGE then
					local client_id = command_body.client_id
					local command_message = json.decode(command_body.message)

					local message_qualifier = command_message.qualifier

					if message_qualifier == game_messages.REQUEST_PROFILE then
						print(os.date() .. " [SERVER_LOBBY] Request profile, client_id=" .. tostring(client_id))

						local wrapped_profile = components.server.lobby:get_profile(client_id)
						if wrapped_profile then
							local server_message = server_messages:set_profile(wrapped_profile.profile)
							respond_client(current_omgruntime, client_id, server_message)
						else
							print(os.date() .. " [SERVER_LOBBY] Profile was not found while handling request_profile message, client_id=" .. client_id)
						end

					elseif message_qualifier == game_messages.REQUEST_MATCHMAKING then
						local new_nickname = command_message.nickname
						print(os.date() .. " [SERVER_LOBBY] Request matchmaking, client_id=" .. tostring(client_id) .. ", nickname=" .. tostring(new_nickname))

						local wrapped_profile = components.server.lobby:get_profile(client_id)
						local current_nickname = wrapped_profile.profile.data.nickname

						if new_nickname and current_nickname ~= new_nickname then
							wrapped_profile:change_nickname(new_nickname)

							omgruntime:set_profile(client_id, wrapped_profile.profile)
							local server_message = server_messages:set_profile(wrapped_profile.profile)
							respond_client(current_omgruntime, client_id, server_message)
						end

						omgruntime:request_matchmaking(client_id, DEFAULT_GAME_MODE)
					else
						print(os.date() .. " [SERVER_LOBBY] Unknown message qualifier was received, message_qualifier=" .. tostring(message_qualifier))
					end
				end
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return server_lobby