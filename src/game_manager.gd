extends Node

const Player = preload("player.gd")
const Ship = preload("ship.gd")

var ship: Ship
var players := []

func load_ship(resource: String) -> Ship:
	var scene = load(resource)
	ship = scene.instance()
	get_tree().get_root().add_child(ship)
	return ship

func spawn_player() -> Player:
	var new_player = Player.new()
	get_tree().get_root().add_child(new_player)
	new_player.add_to_group("players")
	players.push_back(new_player)
	return new_player