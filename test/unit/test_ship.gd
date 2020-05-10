extends "res://addons/gut/test.gd"

func test_ship_load():
	Store.create([
		{'name': 'ship', 'instance': Reducers}
	])
	Store.dispatch(Actions.ship_load("res://test/resources/test_ship_load.tscn"))
	var ship_state = Store.get_state()['ship']

	assert_eq(len(ship_state['rooms']), 2)
	assert_eq(ship_state['rooms'][0]['connected_corridors'], [0])
	assert_eq(ship_state['rooms'][1]['connected_corridors'], [0])

	assert_eq(len(ship_state['corridors']), 1)
	assert_eq(ship_state['corridors'][0]['connected_rooms'], [0, 1])
	
