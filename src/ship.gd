extends Spatial

# export(Resource) var resource

# onready var rooms: Array = resource.rooms
# onready var corridors: Array = resource.corridors

# func _process(_dt: float):
# 	for room in rooms:
# 		DrawLine3d.DrawCube(room.position, 0.2, Color(1, 1, 1))
	
# 	for corridor in corridors:
# 		for i in corridor.rooms:
# 			var room1 = rooms[i]
# 			for j in corridor.rooms:
# 				var room2 = rooms[j]
# 				DrawLine3d.DrawLine(room1.position, room2.position, Color(1, 1, 1))

func get_rooms() -> Array:
	return $Rooms.get_children()

func get_corridors() -> Array:
	return $Corridors.get_children()

func _process(_dt: float):
	for room in get_rooms():
		DrawLine3d.DrawCube(room.global_transform.origin, 0.2, Color(1, 1, 1))
	
	for corridor in get_corridors():
		for room1_node_path in corridor.connected_rooms:
			var room1 = corridor.get_node(room1_node_path)
			for room2_node_path in corridor.connected_rooms:
				var room2 = corridor.get_node(room2_node_path)
				if room1 != room2:
					DrawLine3d.DrawLine(room1.global_transform.origin, room2.global_transform.origin, Color(1, 1, 1))
