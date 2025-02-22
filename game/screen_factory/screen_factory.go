components {
  id: "screen_factory"
  component: "/game/screen_factory/screen_factory.script"
}
embedded_components {
  id: "auth_factory"
  type: "collectionfactory"
  data: "prototype: \"/screens/auth_screen/auth_screen.collection\"\n"
  ""
}
embedded_components {
  id: "lobby_factory"
  type: "collectionfactory"
  data: "prototype: \"/screens/lobby_screen/lobby_screen.collection\"\n"
  ""
}
embedded_components {
  id: "match_factory"
  type: "collectionfactory"
  data: "prototype: \"/screens/match_screen/match_screen.collection\"\n"
  ""
}
embedded_components {
  id: "leaving_factory"
  type: "collectionfactory"
  data: "prototype: \"/screens/leaving_screen/leaving_screen.collection\"\n"
  ""
}
embedded_components {
  id: "joining_factory"
  type: "collectionfactory"
  data: "prototype: \"/screens/joining_screen/joining_screen.collection\"\n"
  ""
}
embedded_components {
  id: "ops_factory"
  type: "collectionfactory"
  data: "prototype: \"/screens/ops_screen/ops_screen.collection\"\n"
  ""
}
