-- Client
local client_camera_system = require("project.client.systems.client_camera_system")
local client_level_system = require("project.client.systems.client_level_system")
local client_pointer_system = require("project.client.systems.client_pointer_system")
local client_root_system = require("project.client.systems.client_root_system")
local client_screen_system = require("project.client.systems.client_screen_system")
local client_skin_system = require("project.client.systems.client_skin_system")
-- Screen
local client_auth_screen = require("project.screen.systems.client_auth_screen")
local client_joining_screen = require("project.screen.systems.client_joining_screen")
local client_leaving_screen = require("project.screen.systems.client_leaving_screen")
local client_lobby_screen = require("project.screen.systems.client_lobby_screen")
local client_match_screen = require("project.screen.systems.client_match_screen")
local client_ops_screen = require("project.screen.systems.client_ops_screen")
-- Server
local server_level_system = require("project.server.systems.server_level_system")
local server_lobby_system = require("project.server.systems.server_lobby_system")
local server_match_system = require("project.server.systems.server_match_system")
local server_root_system = require("project.server.systems.server_root_system")
local server_simulator_system = require("project.server.systems.server_simulator_system")
-- Shared
local shared_bootstrap_system = require("project.shared.systems.shared_bootstrap_system")
local shared_movement_system = require("project.shared.systems.shared_movement_system")
local shared_event_system = require("project.shared.systems.shared_event_system")

local game_systems
game_systems = {
	create = function(self, components)
		local systems = {
			-- Client
			client_camera_system:create(),
			client_level_system:create(),
			client_pointer_system:create(),
			client_root_system:create(),
			client_screen_system:create(),
			client_skin_system:create(),
			-- Screen
			client_auth_screen:create(),
			client_joining_screen:create(),
			client_leaving_screen:create(),
			client_lobby_screen:create(),
			client_match_screen:create(),
			client_ops_screen:create(),
			-- Server
			server_level_system:create(),
			server_lobby_system:create(),
			server_match_system:create(),
			server_root_system:create(),
			server_simulator_system:create(),
			-- Shared
			shared_bootstrap_system:create(),
			shared_movement_system:create(),
			shared_event_system:create(),
		}

		print("Game systems, total=" .. #systems)
		for i = 1,#systems do
			local system = systems[i]
			print(" - " .. system.qualifier)
		end
		
		return {
			id = "game_systems",
			-- Methods
			update = function(instance, dt)
				for system_index = 1, #systems do
					local system = systems[system_index]
					if system:predicate(components) then
						local events = components.game_events:get_events()
						for event_index = 1, #events do
							local event = events[event_index]
							local qualifier = event.id
							if system[qualifier] then
								system[qualifier](system, components, event)
							end
						end
						system:update(dt, components)
					end
				end
			end,
		}
	end
}

return game_systems