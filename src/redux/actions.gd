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

func ship_load(resource: String):
	return {
		"type": ActionTypes.SHIP_LOAD,
		"resource": resource,
	}

func entity_spawn():
	return {
		"type": ActionTypes.ENTITY_SPAWN,
	}

func entity_move(entity: int, room: int):
	return {
		"type": ActionTypes.ENTITY_MOVE,
		"entity": entity,
		"room": room,
	}
