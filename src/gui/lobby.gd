extends Node

var _player_entries := {}

func _ready():
	for id in Store.get_state().players:
		_add_player_entry(id)

	Server.connect("players_changed", self,  "_on_players_changed")

func _on_players_changed(current, _previous):
	for id in _player_entries:
		_remove_player_entry(id)
	for id in current:
		_add_player_entry(id)

func _add_player_entry(id: int):
	var player = Store.get_state().players[id]
	var label = Label.new()
	label.text = player.name
	$"VBoxContainer/Panel/VBoxContainer".add_child(label)
	_player_entries[id] = label

func _remove_player_entry(id: int):
	$"VBoxContainer/Panel/VBoxContainer".remove_child(_player_entries[id])
	_player_entries[id].free()
	_player_entries.erase(id)

func _on_StartButton_pressed():
	Server.start_load_game()

func _on_CancelButton_pressed():
	Store.dispatch(Actions.player_disconnected(get_tree().get_network_unique_id()))
	get_tree().network_peer = null
	get_tree().change_scene("res://scenes/main_menu.tscn")
