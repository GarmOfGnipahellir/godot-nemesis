extends Node


func game_start():
	return {
		"type": ActionTypes.GAME_START,
	}


func round_start():
	return {
		"type": ActionTypes.ROUND_START,
	}


func round_end(did_pass: bool):
	return {
		"type": ActionTypes.ROUND_END,
		"did_pass": did_pass,
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


func entity_spawn(controller: int):
	return {
		"type": ActionTypes.ENTITY_SPAWN,
		"controller": controller,
	}


func entity_move(entity: int, room: int):
	return {
		"type": ActionTypes.ENTITY_MOVE,
		"entity": entity,
		"room": room,
	}
