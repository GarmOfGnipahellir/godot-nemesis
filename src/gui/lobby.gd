extends Node

var _player_entries = {}

func _ready():
	for id in Store.get_state().players:
		_add_player_entry(id)

	Main.connect("player_connected", self,  "_add_player_entry")
	Main.connect("player_disconnected", self,  "_remove_player_entry")

func _add_player_entry(id: int):
	var player = Store.get_state().players[id]
	var label = Label.new()
	label.text = player.name
	$"../VBoxContainer/Panel/VBoxContainer".add_child(label)
	_player_entries[id] = label

func _remove_player_entry(id: int):
	$"../VBoxContainer/Panel/VBoxContainer".remove_child(_player_entries[id])
	_player_entries[id].free()
	_player_entries.erase(id)

func _on_StartButton_pressed():
	rpc("load_game_scene")

func _on_CancelButton_pressed():
	Store.dispatch(Actions.player_disconnected(get_tree().get_network_unique_id()))
	get_tree().network_peer = null
	get_tree().change_scene("res://scenes/main_menu.tscn")

remotesync func load_game_scene():
	get_tree().change_scene("res://scenes/default_scene.tscn")