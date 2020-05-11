extends Node

func game(state, action):
	if action["type"] == ActionTypes.GAME_SET_START_TIME:
		var next_state = Store.shallow_copy(state)
		next_state["start_time"] = action["time"]
		return next_state
	return state

func ship(state, action):
	match action["type"]:
		ActionTypes.SHIP_LOAD:
			var next_state = Store.shallow_copy(state)
			var scene = load(action["resource"])
			var ship = scene.instance()
			var room_nodes = ship.get_rooms()
			var corridor_nodes = ship.get_corridors()

			var rooms = []
			for room_node in room_nodes:
				rooms.push_back({
					"connected_corridors": []
				})
			
			var corridors = []
			for corridor_node in corridor_nodes:
				var connected_rooms = []
				for connected_room in corridor_node.connected_rooms:
					var i = 0
					for room_node in room_nodes:
						if corridor_node.get_node(connected_room) == room_node:
							connected_rooms.push_back(i)
							rooms[i]["connected_corridors"].push_back(len(corridors))
							break
						i += 1
				corridors.push_back({
					"connected_rooms": connected_rooms
				})

			ship.free()
			
			next_state["resource"] = action["resource"]
			next_state["rooms"] = rooms
			next_state["corridors"] = corridors
			return next_state
	return state

func players(state, action):
	match action["type"]:
		ActionTypes.PLAYER_SPAWN:
			var next_state = Store.shallow_copy(state)
			var index = len(next_state)
			next_state[index] = {
				"room": 0
			}
			return next_state
		ActionTypes.PLAYER_MOVE:
			var player_state = Store.shallow_copy(state[action["player"]])
			var ship_state = Store.get_state()["ship"]

			var can_move = false
			var current_room = ship_state["rooms"][player_state["room"]]
			for corridor_id in current_room["connected_corridors"]:
				var corridor = ship_state["corridors"][corridor_id]
				for corridor_room_id in corridor["connected_rooms"]:
					if corridor_room_id == action["room"]:
						can_move = true
						break
				if can_move:
					break

			if can_move:
				player_state["room"] = action["room"]
			
			var next_state = Store.shallow_copy(state)
			next_state[action["player"]] = player_state
			return next_state
	return state
