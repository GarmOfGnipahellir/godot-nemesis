extends Node

func gui_set_name(name: String):
	return {
		"type": ActionTypes.GUI_SET_NAME,
		"name": name,
	}

func player_connected(rpc_id: int, name: String):
	return {
		"type": ActionTypes.PLAYER_CONNECTED,
		"rpc_id": rpc_id,
		"name": name,
	}

func player_disconnected(rpc_id: int):
	return {
		"type": ActionTypes.PLAYER_DISCONNECTED,
		"rpc_id": rpc_id,
	}

func player_spawn():
	return {
		"type": ActionTypes.PLAYER_SPAWN,
	}

func player_move(player: int, room: int):
	return {
		"type": ActionTypes.PLAYER_MOVE,
		"player": player,
		"room": room,
	}

func ship_load(resource: String):
	return {
		"type": ActionTypes.SHIP_LOAD,
		"resource": resource,
	}
