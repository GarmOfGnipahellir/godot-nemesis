extends EditorSpatialGizmo

func redraw():
	clear()

	var spatial := get_spatial_node()
	var rooms = spatial.resource.rooms

	var lines := PoolVector3Array()
	
	for room1 in rooms:
		for room2 in rooms:
			if room1 == room2:
				continue
			lines.push_back(room1.position)
			lines.push_back(room2.position)
	
	var material = get_plugin().get_material("main", self)
	add_lines(lines, material, false)

	var handles := PoolVector3Array()

	for room in rooms:
		handles.push_back(room.position)

	material = get_plugin().get_material("handles", self)
	add_handles(handles, material)

func set_handle(index: int, camera: Camera, point: Vector2):
	var spatial := get_spatial_node()

	var ray_origin = camera.project_ray_origin(point)
	var ray_normal = camera.project_ray_normal(point)
	var plane_origin = Vector3(0, 0, 0)
	var plane_normal = Vector3(0, 1, 0)

	var t = plane_normal.dot(ray_origin - plane_origin) / plane_normal.dot(-ray_normal)

	spatial.resource.rooms[index].position = ray_origin + ray_normal * t

	redraw()