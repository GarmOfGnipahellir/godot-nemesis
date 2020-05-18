extends Node

#warning-ignore: unused_signal
signal players_changed(state, prev_state)
#warning-ignore: unused_signal
signal ship_changed(state, prev_state)
#warning-ignore: unused_signal
signal entities_changed(state, prev_state)

const Players = preload("players.gd")

var logger = Logger.get_logger("server.gd")

var _prev_state
var _local_player_name
var _players: Players

func _ready():
	call_deferred("_tree_ready")

func _tree_ready():
	# TODO should add a way to reset store for tests
	Store.create([
		{"name": "players", "instance": Reducers},
		{"name": "ship", "instance": Reducers},
		{"name": "entities", "instance": Reducers},
	], [
		{"name": "_on_store_changed", "instance": self},
	])
	_prev_state = Store.get_state().duplicate(true)

	_players = Players.new()
	add_child(_players)

func _on_store_changed(name, current):
	logger.start("_on_store_changed()")

	if get_tree().network_peer and get_tree().is_network_server():
		rpc("_remotesync_state_update", name, current)
	
	var previous = _prev_state[name]

	logger.info("\n  previous -> %s: %s\n  current  -> %s: %s" % [name, previous, name, current])
	
	emit_signal("%s_changed" % [name], current, previous)

	_prev_state = Store.get_state().duplicate(true)

remote func _remotesync_state_update(name, current):
	Store.state_update(name, current)

func dispatch(action):
	if get_tree().is_network_server():
		Store.dispatch(action)
	else:
		rpc_id(1, "_master_dispatch", action)

master func _master_dispatch(action):
	dispatch(action)

func host(name: String):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(25565, 5)

	get_tree().network_peer = peer
	
	# register local player
	_local_player_name = name
	Store.dispatch(Actions.player_connected(
		get_tree().get_network_unique_id(), 
		_local_player_name))

func join(adress: String, name: String):
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(adress, 25565)
	peer.connect("connection_succeeded", self, "_on_connection_succeeded")
	
	get_tree().network_peer = peer

	_local_player_name = name

func _on_connection_succeeded():
	# send my info to the server
	_players.register_self(_local_player_name)

func start_load_game():
	rpc("_remotesync_start_load_game")

remotesync func _remotesync_start_load_game():
	get_tree().change_scene("res://scenes/world.tscn")
	
	if get_tree().network_peer and get_tree().is_network_server():
		_done_load_game(1)
	else:
		rpc_id(1, "_master_done_load_game")

master func _master_done_load_game():
	_done_load_game(get_tree().get_rpc_sender_id())

var _players_done := []
func _done_load_game(id: int):
	_players_done.push_back(id)
	if len(_players_done) == len(Store.get_state().players):
		Server.dispatch(Actions.ship_load("res://default_ship.tscn"))
		for player in Store.get_state().players.values():
			Server.dispatch(Actions.entity_spawn(player.id))
