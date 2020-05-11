extends Node

var prev_state

signal player_connected(id)
signal player_disconnected(id)

func _ready():
	Store.create([
		{'name': 'gui', 'instance': Reducers},
		{'name': 'players', 'instance': Reducers},
		{'name': 'ship', 'instance': Reducers},
		{'name': 'entities', 'instance': Reducers},
	], [
		{'name': '_on_store_changed', 'instance': self},
	])
	prev_state = Store.get_state().duplicate(true)

	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _on_store_changed(name, state):
	print(name, ': prev -> ', prev_state[name])
	print(name, ': now  -> ', state, '\n')

	match name:
		'ship':
			var prev_ship = prev_state['ship']
			var ship = state
			if prev_ship.empty() and not ship.empty():
				var _ship_node = GameManager.load_ship(ship['resource'])
		'entities':
			pass
		'players':
			var prev_players = prev_state['players']
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
			for player_id in state:
				if not prev_players.has(player_id):
					# player just spawned and should be setup at spawn
					continue
				# var prev_player = prev_players[player_id]
				# var player = players[player_id]
				# if player['room'] != prev_player['room']:
				# 	GameManager.players[player_id].global_transform.origin = GameManager.ship.get_rooms()[player['room']].global_transform.origin

	prev_state = Store.get_state().duplicate(true)


func _player_connected(id: int):
	rpc_id(id, "register_player", Store.get_state().gui.name)

func _player_disconnected(id: int):
	Store.dispatch(Actions.player_disconnected(id))

remote func register_player(name: String):
	var id = get_tree().get_rpc_sender_id()
	Store.dispatch(Actions.player_connected(id, name))
