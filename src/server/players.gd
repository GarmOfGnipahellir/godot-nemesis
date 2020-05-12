extends Node
# The bridge for player connections between godot networking and the redux state

func register_self(name: String):
	rpc_id(1, "_remote_register_player", name)

master func _remote_register_player(name: String):
	var id = get_tree().get_rpc_sender_id()
	Server.dispatch(Actions.player_connected(id, name))