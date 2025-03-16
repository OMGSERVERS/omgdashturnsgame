-- Client
local client_camera = require("project.client.systems.client_camera")
local client_level = require("project.client.systems.client_level")
local client_pointer = require("project.client.systems.client_pointer")
local client_root = require("project.client.systems.client_root")
local client_screen = require("project.client.systems.client_screen")
local client_skin = require("project.client.systems.client_skin")
-- Screen
local client_auth = require("project.screen.systems.screen_auth")
local screen_joining = require("project.screen.systems.screen_joining")
local screen_leaving = require("project.screen.systems.screen_leaving")
local screen_lobby = require("project.screen.systems.screen_lobby")
local screen_match = require("project.screen.systems.screen_match")
local screen_ops = require("project.screen.systems.screen_ops")
-- Server
local server_level = require("project.server.systems.server_level")
local server_lobby = require("project.server.systems.server_lobby")
local server_match = require("project.server.systems.server_match")
local server_root = require("project.server.systems.server_root")
local server_simulator = require("project.server.systems.server_simulator")
-- Shared
local shared_bootstrap = require("project.shared.systems.shared_bootstrap")
local shared_movement = require("project.shared.systems.shared_movement")
local shared_event = require("project.shared.systems.shared_event")

local game_systems
game_systems = {
	create = function(self, components)
		local systems = {
			-- Client
			client_camera:create(),
			client_level:create(),
			client_pointer:create(),
			client_root:create(),
			client_screen:create(),
			client_skin:create(),
			-- Screen
			client_auth:create(),
			screen_joining:create(),
			screen_leaving:create(),
			screen_lobby:create(),
			screen_match:create(),
			screen_ops:create(),
			-- Server
			server_level:create(),
			server_lobby:create(),
			server_match:create(),
			server_root:create(),
			server_simulator:create(),
			-- Shared
			shared_bootstrap:create(),
			shared_movement:create(),
			shared_event:create(),
		}

		print("Systems, total=" .. #systems)
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
						local events = components.shared.events:get_events()
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