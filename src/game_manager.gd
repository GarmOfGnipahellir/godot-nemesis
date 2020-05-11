extends Node

const Ship = preload("ship.gd")
const Player = preload("player.gd")
const Entity = preload("entity.gd")

var player: Player
var ship: Ship
var entities := []

func create_player() -> Player:
	player = Player.new()
	get_tree().get_root().add_child(player)
	return player

func load_ship(resource: String) -> Ship:
	var scene = load(resource)
	ship = scene.instance()
	get_tree().get_root().add_child(ship)
	return ship

func spawn_entity() -> Entity:
	var new_entity = Entity.new()
	get_tree().get_root().add_child(new_entity)
	entities.push_back(new_entity)
	return new_entity