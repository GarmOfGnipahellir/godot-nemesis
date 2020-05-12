extends Node

var _name_popup_callback
var _name: String
var _adress: String

func start_single_player():
	Store.dispatch(Actions.gui_set_name("Local"))

	Server.host("Local")
	
	if get_tree().change_scene("res://scenes/lobby.tscn") != OK:
		push_error("Couldn't load scene")

func host_game():
	Store.dispatch(Actions.gui_set_name("Server"))

	Server.host(_name)

	if get_tree().change_scene("res://scenes/lobby.tscn") != OK:
		push_error("Couldn't load scene")

func join_game():
	Store.dispatch(Actions.gui_set_name("Client"))

	Server.join(_adress, _name)

	if get_tree().change_scene("res://scenes/lobby.tscn") != OK:
		push_error("Couldn't load scene")

func _ready():
	$"Panel".set_visible(false)

func _show_name_popup(continue_method: String):
	$"Panel/VBoxContainer/HBoxContainer/ContinueButton".connect("pressed", self, continue_method)
	$"Panel".set_visible(true)

func _on_JoinButton_pressed():
	$"Panel/VBoxContainer/Adress".set_visible(true)
	_show_name_popup("join_game")

func _on_HostButton_pressed():
	$"Panel/VBoxContainer/Adress".set_visible(false)
	_show_name_popup("host_game")

func _on_LineEdit_text_changed(new_text):
	_name = new_text

func _on_Adress_text_changed(new_text):
	_adress = new_text

func _on_CancelButton_pressed():
	$"Panel".set_visible(false)
