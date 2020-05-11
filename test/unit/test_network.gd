extends "res://addons/gut/test.gd"

func before_all():
	OS.execute("godot", ["-s", "test/server.gd"], false)
	yield_for(1.0)

func test_network():
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_client("127.0.0.1", 25565) != OK:
		print("Couldn't connect to server.")
	get_tree().network_peer = peer

	Store.dispatch(Actions.gui_set_name("Test Client"))