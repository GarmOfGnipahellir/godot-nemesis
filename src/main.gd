extends Node

var prev_state

signal player_connected(id)
signal player_disconnected(id)
signal ship_changed(state, prev_state)
signal entities_changed(state, prev_state)

func _ready():
	# TODO should add a way to reset store for tests
	Store.create([
		{"name": "gui", "instance": Reducers},
		{"name": "players", "instance": Reducers},
		{"name": "ship", "instance": Reducers},
		{"name": "entities", "instance": Reducers},
	], [
		{"name": "_on_store_changed", "instance": self},
	])
	prev_state = Store.get_state().duplicate(true)

	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _on_store_changed(name, state):
	print(name, ": prev -> ", prev_state[name])
	print(name, ": now  -> ", state, "\n")

	match name:
		"ship":
			emit_signal("ship_changed", state, prev_state[name])
		"entities":
			emit_signal("entities_changed", state, prev_state[name])
		"players":
			var prev_players = prev_state.players
			var players = state
			if len(prev_players) < len(players):
				for id in players:
					if prev_players.has(id):
						continue
					emit_signal("player_connected", id)
			elif len(prev_players) > len(players):
				for id in prev_players:
					if players.has(id):
						continue
					emit_signal("player_disconnected", id)
	prev_state = Store.get_state().duplicate(true)


func _player_connected(id: int):
	rpc_id(id, "register_player", Store.get_state().gui.name)

func _player_disconnected(id: int):
	Store.dispatch(Actions.player_disconnected(id))

remote func register_player(name: String):
	var id = get_tree().get_rpc_sender_id()
	Store.dispatch(Actions.player_connected(id, name))
