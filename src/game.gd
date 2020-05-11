extends Node

func _ready():
	call_deferred("prepare_game")

func prepare_game():
	Store.dispatch(Actions.ship_load("res://default_ship.tscn"))
	Store.dispatch(Actions.player_spawn())

	start_game()

func start_game():
	pass
