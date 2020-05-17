extends Spatial

var color: Color
var controller: int

var _player_name

func _ready():
	_player_name = Store.get_state().players[controller].name

func _process(_dt: float):
	DrawLine3d.DrawCube(global_transform.origin, 0.1, color)
	DrawLine3d.DrawText(global_transform.origin + Vector3(0, 0.5, 0), _player_name, color)
