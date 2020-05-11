extends Node

func game_set_start_time(time):
	return {
		"type": ActionTypes.GAME_SET_START_TIME,
		"time": time,
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
