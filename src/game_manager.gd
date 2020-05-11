extends Node

const Ship = preload("ship.gd")
const Player = preload("player.gd")
const Entity = preload("entity.gd")

const COLORS = [
	Color8(25, 130, 196),
	Color8(106, 76, 147),
	Color8(138, 201, 38),
	Color8(255, 202, 58),
	Color8(255, 89, 94),
]

var player: Player
var ship: Ship
var entities := []

func create_player():
	rpc("_remote_create_player")

remotesync func _remote_create_player():
	var peer_id = get_tree().get_network_unique_id()
	player = Player.new()
	player.name = str(peer_id)
	player.set_network_master(peer_id)
	get_tree().get_root().add_child(player)

func load_ship(resource: String) -> Ship:
	var scene = load(resource)
	ship = scene.instance()
	get_tree().get_root().add_child(ship)
	return ship

func spawn_entity() -> Entity:
	var new_entity = Entity.new()
	new_entity.color = COLORS[len(entities)]
	get_tree().get_root().add_child(new_entity)
	entities.push_back(new_entity)
	return new_entity