extends Spatial
class_name RoomProperties

enum ITEMTYPES{
	ITEM_NONE,
	ITEM_RED,
	ITEM_YELLOW,
	ITEM_GREEN,
	ITEM_WHITE
}

enum SPECIALEFFECTS{
	EFFECT_SILENCE,
	EFFECT_DANGER,
	EFFECT_SLIME,
	EFFECT_FIRE,
	EFFECT_MALFUNCTION,
	EFFECT_DOOR
}

export(Vector3) var position

export(int) var room_number := 1
export(int) var items := 0
export(ITEMTYPES) var item_type := ITEMTYPES.ITEM_NONE

export(bool) var has_computer := false
export(bool) var can_mulfunction := true
var on_fire := false
var malfunction := false
var explored := false

var monsters_in_room := []
var dropped_items_in_room := []
# could be Intruder Egg/Intruder Carcass/Character Corpse
var object_tokens_in_room := []

export(Array, NodePath) var connected_corridors

var exploration_token = {
	"number_of_items": 2,
	# could be Silence/Danger/Slime/Fire/Malfunction/Door
	"special_effect": SPECIALEFFECTS.EFFECT_DOOR
}