extends Node

var _name_popup_callback

func start_single_player():
	if get_tree().change_scene("res://scenes/default_scene.tscn") != OK:
		print("Couldn't load scene")

func host_game():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(25565, 5)
	get_tree().network_peer = peer

	Store.dispatch(Actions.player_connected(
		get_tree().get_network_unique_id(), 
		Store.get_state().gui.name))

	if get_tree().change_scene("res://scenes/lobby.tscn") != OK:
		print("Couldn't load scene")

func join_game():
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_client("127.0.0.1", 25565) != OK:
		print("Couldn't conenct to server")
	get_tree().network_peer = peer

	Store.dispatch(Actions.player_connected(
		get_tree().get_network_unique_id(), 
		Store.get_state().gui.name))

	if get_tree().change_scene("res://scenes/lobby.tscn") != OK:
		print("Couldn't load scene")

func _ready():
	var gui_state = Store.get_state().gui
	if gui_state.has("name"):
		$"../Panel/VBoxContainer/LineEdit".set_text(gui_state.name)
	$"../Panel".set_visible(false)

func _show_name_popup(continue_method: String):
	$"../Panel/VBoxContainer/HBoxContainer/ContinueButton".connect("pressed", self, continue_method)
	$"../Panel".set_visible(true)

func _on_JoinButton_pressed():
	_show_name_popup("join_game")

func _on_HostButton_pressed():
	_show_name_popup("host_game")

func _on_LineEdit_text_changed(new_text):
	Store.dispatch(Actions.gui_set_name(new_text))

func _on_CancelButton_pressed():
	$"../Panel".set_visible(false)
