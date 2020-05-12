extends Control

func _on_LoadShip_pressed():
	Store.rpc_dispatch(Actions.ship_load("res://default_ship.tscn"))

func _on_SpawnEntity_pressed():
	Store.rpc_dispatch(Actions.entity_spawn(1))