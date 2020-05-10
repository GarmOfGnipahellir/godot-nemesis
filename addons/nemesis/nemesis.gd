tool
extends EditorPlugin

const GizmoPlugin = preload("gizmos/gizmo_plugin.gd")

var gizmo_plugin := GizmoPlugin.new()

var ship_buttons: Control

var edited_object_ref: WeakRef = weakref(null)

func handles(object: Object) -> bool:
	return object is Ship

func edit(object: Object) -> void:
	edited_object_ref = weakref(object)

func make_visible(visible: bool):
	if ship_buttons:
		ship_buttons.set_visible(visible)

func _enter_tree():
	add_spatial_gizmo_plugin(gizmo_plugin)
	
	ship_buttons = create_ship_buttons()
	ship_buttons.set_visible(false)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, ship_buttons)

func _exit_tree():
	remove_spatial_gizmo_plugin(gizmo_plugin)

	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, ship_buttons)
	ship_buttons.queue_free()
	ship_buttons = null

func create_ship_buttons() -> Control:
	var control = HBoxContainer.new()

	control.add_child(VSeparator.new())

	var icon = TextureRect.new()
	icon.texture = preload("icons/default.png")
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	control.add_child(icon)

	var add_room_button = ToolButton.new()
	add_room_button.text = "Add Room"
	add_room_button.connect("pressed", self, "ship_add_room")
	control.add_child(add_room_button)

	return control

func ship_add_room() -> void:
	var edited_object = edited_object_ref.get_ref()
	if edited_object is Ship:
		edited_object.resource.rooms.push_back(RoomResource.new())
		edited_object.update_gizmo()