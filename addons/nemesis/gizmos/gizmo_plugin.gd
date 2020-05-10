extends EditorSpatialGizmoPlugin

const ShipGizmo = preload("ship_gizmo.gd")

func _init():
	create_material("main", Color(1, 1, 1))
	create_handle_material("handles")

func get_name():
	return "Ship"

func create_gizmo(spatial):
	if spatial is Ship:
		return ShipGizmo.new()
	else:
		return null