extends EditorSpatialGizmo

var handle_pos: Vector3

func redraw():
	clear()

	var spatial = get_spatial_node()

	var lines = PoolVector3Array()

	lines.push_back(Vector3(0, 0, 0))
	lines.push_back(handle_pos)

	var handles = PoolVector3Array()

	handles.push_back(handle_pos)

	var material = get_plugin().get_material("main", self)
	add_lines(lines, material, false)

	var handles_material = get_plugin().get_material("handles", self)
	add_handles(handles, handles_material)

func set_handle(index: int, camera: Camera, point: Vector2):
	var spatial = get_spatial_node()
	var rooms = spatial.get_tree().get_nodes_in_group("rooms")

	var closest_dist: float = INF
	var closest_room: Spatial = null
	for room in rooms:
		var room_point = camera.unproject_position(room.global_transform.origin)
		var dist = point.distance_to(room_point)

		if dist < closest_dist:
			closest_dist = dist
			closest_room = room

	var ray_origin = camera.project_ray_origin(point)
	var ray_normal = camera.project_ray_normal(point)
	var plane_origin = Vector3(0, 0, 0)
	var plane_normal = Vector3(0, 1, 0)

	var t = plane_normal.dot(ray_origin - plane_origin) / plane_normal.dot(-ray_normal)

	handle_pos = ray_origin + ray_normal * t
	handle_pos = closest_room.global_transform.origin - spatial.global_transform.origin

	redraw()
