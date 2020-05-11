extends Spatial

func _process(_dt: float):
	DrawLine3d.DrawCube(Vector3(global_transform.origin), 0.1,  Color(0, 1, 0))
