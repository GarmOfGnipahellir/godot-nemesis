extends Node

const Entity = preload("entity.gd");

func _ready():
	Main.connect("ship_changed", self, "_on_ship_changed")
	Main.connect("entities_changed", self, "_on_entities_changed")

	call_deferred("prepare_game")

func _on_ship_changed(state, prev_state):
	if prev_state.empty() and not state.empty():
		GameManager.load_ship(state.resource)

func _on_entities_changed(state, prev_state):
	for id in state:
		if len(prev_state) < len(state):
			for id in state:
				if prev_state.has(id):
					continue
				# entity spawned
				var new_entity = GameManager.spawn_entity()
				print(GameManager.players)
				GameManager.players[state[id].controller].controlled_entity = id
				new_entity.global_transform.origin = (
					GameManager.ship.get_rooms()[state[id].room].global_transform.origin)

		elif len(prev_state) > len(state):
			for id in prev_state:
				if state.has(id):
					continue
				# entity removed
		
		if not prev_state.has(id):
			# entity just spawned
			continue
		var prev_entity = prev_state[id]
		var entity = state[id]
		if entity.room != prev_entity.room:
			GameManager.entities[id].global_transform.origin = (
				GameManager.ship.get_rooms()[entity.room].global_transform.origin)

func prepare_game():
	Store.rpc_dispatch(Actions.ship_load("res://default_ship.tscn"))
	
	for player in Store.get_state().players.values():
		GameManager.create_player(player.id)
		# Store.rpc_dispatch(Actions.entity_spawn(player.id))
	
	print(GameManager.players)
