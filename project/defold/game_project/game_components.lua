-- Client
local client_kills = require("project.client.components.client_kills")
local client_screen = require("project.client.components.client_screen")
local client_state = require("project.client.components.client_state")
-- Screen
local screen_auth = require("project.screen.components.screen_auth")
local screen_joining = require("project.screen.components.screen_joining")
local screen_leaving = require("project.screen.components.screen_leaving")
local screen_lobby = require("project.screen.components.screen_lobby")
local screen_match = require("project.screen.components.screen_match")
local screen_ops = require("project.screen.components.screen_ops")
-- Server
local server_lobby = require("project.server.components.server_lobby")
local server_match = require("project.server.components.server_match")
local server_simulator = require("project.server.components.server_simulator")
local server_state = require("project.server.components.server_state")
-- Shared
local shared_bootstrap = require("project.shared.components.shared_bootstrap")
local shared_events = require("project.shared.components.shared_events")
local shared_level = require("project.shared.components.shared_level")
local shared_movements = require("project.shared.components.shared_movements")
local shared_players = require("project.shared.components.shared_players")
local shared_state = require("project.shared.components.shared_state")

local game_components
game_components = {
	create = function(self)
		local components = {
			client = {
				kills = client_kills:create(),
				screen = client_screen:create(),
				state = client_state:create(),
			},
			screen = {
				auth = screen_auth:create(),
				lobby = screen_lobby:create(),
				joining = screen_joining:create(),
				leaving = screen_leaving:create(),
				match = screen_match:create(),
				ops = screen_ops:create(),
			},
			server =  {
				state = server_state:create(),
				lobby = server_lobby:create(),
				match = server_match:create(),
				simulator = server_simulator:create(),
			},
			shared = {
				bootstrap = shared_bootstrap:create(),
				events = shared_events:create(),
				level = shared_level:create(),
				movements = shared_movements:create(),
				players = shared_players:create(),
				state = shared_state:create(),
			},
		}

		local total = 0
		for group, group_components in pairs(components) do
			for _ in pairs(group_components) do
				total = total + 1
			end
		end

		print("Components, total=" .. total)
		for group, group_components in pairs(components) do
			for key, component in pairs(group_components) do
				print(" - " .. tostring(component.qualifier))
			end
		end
		
		return components
	end
}

return game_components