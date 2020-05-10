extends Node

var prev_state

func _ready():
	Store.create([
		{'name': 'game', 'instance': Reducers},
		{'name': 'players', 'instance': Reducers},
		{'name': 'ship', 'instance': Reducers}
	], [
		{'name': '_on_store_changed', 'instance': self}
	])

	prev_state = Store.get_state().duplicate(true)
	
	call_deferred("prepare_game")

func _on_store_changed(name, state):
	print(name, ': prev -> ', prev_state[name])
	print(name, ': now  -> ', state)

	match name:
		'ship':
			var prev_ship = prev_state['ship']
			var ship = state
			if prev_ship.empty() and not ship.empty():
				var _ship_node = GameManager.load_ship(ship['resource'])
		'players':
			var prev_players = prev_state['players']
			var players = state
			if len(prev_players) < len(players):
				var player_node = GameManager.spawn_player()
				player_node.global_transform.origin = GameManager.ship.get_rooms()[0].global_transform.origin
			elif len(prev_players) > len(players):
				# TODO handle player removed
				pass
			for player_id in state:
				if not prev_players.has(player_id):
					# player just spawned and should be setup at spawn
					continue
				var prev_player = prev_players[player_id]
				var player = players[player_id]
				if player['room'] != prev_player['room']:
					GameManager.players[player_id].global_transform.origin = GameManager.ship.get_rooms()[player['room']].global_transform.origin

	prev_state = Store.get_state().duplicate(true)

func prepare_game():
	Store.dispatch(Actions.ship_load("res://default_ship.tscn"))
	Store.dispatch(Actions.player_spawn())

	start_game()

func start_game():
	Store.dispatch(Actions.player_move(0, 1))
