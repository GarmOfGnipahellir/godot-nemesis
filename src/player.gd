extends Spatial

var controlled_entity: int

func _physics_process(_dt: float):
	var space_state = get_world().direct_space_state
	var camera = get_viewport().get_camera()
	var point = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(point)
	var ray_normal = camera.project_ray_normal(point)
	var result = space_state.intersect_ray(ray_origin, ray_origin + ray_normal * 100)

	if result:
		if Input.is_action_just_pressed("select"):
			var room: Spatial = result.collider.get_parent()
			var room_id := room.get_index()
			Store.dispatch(Actions.entity_move(controlled_entity, room_id))
