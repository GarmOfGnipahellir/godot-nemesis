extends Spatial

var color: Color

func _process(_dt: float):
	DrawLine3d.DrawCube(Vector3(global_transform.origin), 0.1, color)
