extends Spatial
# class_name Ship, "../icons/default.png"

export(Resource) var resource

onready var rooms: Array = resource.rooms
onready var corridors: Array = resource.corridors

func _process(_dt: float):
	for room in rooms:
		DrawLine3d.DrawCube(room.position, 0.1, Color(1, 1, 1))
	
	for corridor in corridors:
		for i in corridor.rooms:
			var room1 = rooms[i]
			for j in corridor.rooms:
				var room2 = rooms[j]
				DrawLine3d.DrawLine(room1.position, room2.position, Color(1, 1, 1))