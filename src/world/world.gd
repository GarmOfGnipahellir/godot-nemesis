extends Spatial
# Handles updating the visual world stuff based on state changes from server

const Player = preload("player.gd")
const Entity = preload("entity.gd")
const COLORS = [
	Color8(25, 130, 196),
	Color8(106, 76, 147),
	Color8(138, 201, 38),
	Color8(255, 202, 58),
	Color8(255, 89, 94),
]

var _players := {}
var _ship
var _entities := {}

func _ready():
	call_deferred("_tree_ready")

func _tree_ready():
	for id in Store.get_state().players:
		_create_player(id)

	_ship_load()

	for id in Store.get_state().entities:
		_entity_spawn(id)

	Server.connect("entities_changed", self, "_on_entities_changed")

func _create_player(id: int):
	var player = Player.new()
	add_child(player)
	player.set_network_master(id)
	_players[id] = player

func _ship_load():
	_ship = load("res://default_ship.tscn").instance()
	add_child(_ship)

func _on_entities_changed(current: Dictionary, previous: Dictionary):
	if len(current) > len(previous):
		# one or more entities has spawned
		for id in current:
			if previous.has(id):
				continue
			
			# should spawn entity node
			_entity_spawn(id)
	
	elif len(current) < len(previous):
		# one or more entities has despawned
		for id in previous:
			if current.has(id):
				continue
			
			# should despawn entity
	
	for id in current:
		if not previous.has(id):
			continue
		
		var entity_cur = current[id]
		var entity_prev = previous[id]

		if entity_cur.room != entity_prev.room:
			_entity_move(id, entity_cur.room)

func _entity_spawn(id: int):
	var state = Store.get_state().entities[id]
	_players[state.controller].controlled_entity = id
	var entity = Entity.new()
	entity.color = COLORS[len(_entities)]
	add_child(entity)
	_entities[id] = entity

func _entity_move(id: int, room: int):
	_entities[id].global_transform.origin = (
		_ship.get_rooms()[room].global_transform.origin)
