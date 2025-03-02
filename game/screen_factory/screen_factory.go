components {
  id: "screen_factory"
  component: "/game/screen_factory/screen_factory.script"
}
embedded_components {
  id: "auth_screen_factory"
  type: "collectionfactory"
  data: "prototype: \"/game/auth_screen/auth_screen.collection\"\n"
  ""
}
embedded_components {
  id: "lobby_screen_factory"
  type: "collectionfactory"
  data: "prototype: \"/game/lobby_screen/lobby_screen.collection\"\n"
  ""
}
embedded_components {
  id: "match_screen_factory"
  type: "collectionfactory"
  data: "prototype: \"/game/match_screen/match_screen.collection\"\n"
  ""
}
embedded_components {
  id: "leaving_screen_factory"
  type: "collectionfactory"
  data: "prototype: \"/game/leaving_screen/leaving_screen.collection\"\n"
  ""
}
embedded_components {
  id: "joining_screen_factory"
  type: "collectionfactory"
  data: "prototype: \"/game/joining_screen/joining_screen.collection\"\n"
  ""
}
embedded_components {
  id: "ops_screen_factory"
  type: "collectionfactory"
  data: "prototype: \"/game/ops_screen/ops_screen.collection\"\n"
  ""
}
