extends SceneTree

var Store
var Actions

func _init():
	Store = get_root().get_node("/root/Store")
	Actions = get_root().get_node("/root/Actions")

	var peer = NetworkedMultiplayerENet.new()
	if peer.create_client("127.0.0.1", 25565) != OK:
		print("Couldn't create to server.")
	network_peer = peer

	Store.dispatch(Actions.gui_set_name("Test Client"))
	
	change_scene("res://test/network/scene.tscn")