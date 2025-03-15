local game_events = require("project.core.components.game_events")
local entrypoint_state = require("project.core.components.entrypoint_state")
local client_state = require("project.client.components.client_state")
local screen_state = require("project.client.components.screen_state")
local auth_screen = require("project.screens.components.auth_screen")
local lobby_screen = require("project.screens.components.lobby_screen")
local joining_screen = require("project.screens.components.joining_screen")
local leaving_screen = require("project.screens.components.leaving_screen")
local match_screen = require("project.screens.components.match_screen")
local ops_screen = require("project.screens.components.ops_screen")
local server_state = require("project.server.components.server_state")
local lobby_runtime = require("project.server.components.lobby_runtime")
local match_runtime = require("project.server.components.match_runtime")
local match_simulator = require("project.server.components.match_simulator")
local match_state = require("project.components.match_state")
local level_state = require("project.level.components.level_state")
local level_players = require("project.level.components.level_players")
local level_movements = require("project.level.components.level_movements")
local level_kills = require("project.level.components.level_kills")
local level_deathmatch = require("project.level.components.level_deathmatch")

local game_components
game_components = {
	create = function(self)
		local components = {
			game_events = game_events:create(),
			entrypoint_state = entrypoint_state:create(),
			client_state = client_state:create(),
			screen_state = screen_state:create(),
			auth_screen = auth_screen:create(),
			lobby_screen = lobby_screen:create(),
			joining_screen = joining_screen:create(),
			leaving_screen = leaving_screen:create(),
			match_screen = match_screen:create(),
			ops_screen = ops_screen:create(),
			server_state = server_state:create(),
			lobby_runtime = lobby_runtime:create(),
			match_runtime = match_runtime:create(),
			match_simulator = match_simulator:create(),
			match_state = match_state:create(),
			level_state = level_state:create(),
			level_players = level_players:create(),
			level_movements = level_movements:create(),
			level_kills = level_kills:create(),
			level_deathmatch = level_deathmatch:create(),
		}

		local total = 0
		for _ in pairs(components) do
			total = total + 1
		end

		print("Game components, total=" .. total)
		for key, _ in pairs(components) do
			local component = components[key]
			print(" - " .. component.qualifier)
		end
		
		return components
	end
}

return game_components