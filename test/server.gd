extends SceneTree

var Store
var Actions

func _init():
	Store = get_root().get_node("/root/Store")
	Actions = get_root().get_node("/root/Actions")

	var peer = NetworkedMultiplayerENet.new()
	if peer.create_server(25565, 5) != OK:
		print("Couldn't create to server.")
	network_peer = peer

	Store.dispatch(Actions.gui_set_name("Test Host"))
	Store.dispatch(Actions.player_connected(get_network_unique_id(), "Test Host"))

	print("Test Server >> Ready for connections!")