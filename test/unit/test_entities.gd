extends "res://addons/gut/test.gd"

func before_each():
	Store.create([
		{"name": "entities", "instance": Reducers},
		{"name": "ship", "instance": Reducers},
	])
	Store.dispatch(Actions.ship_load("res://test/resources/test_ship_move.tscn"))

func test_entity_spawn():
	Store.dispatch(Actions.entity_spawn())
	assert_eq(Store.get_state().entities[0].room, 0)

func test_entity_movement():
	Store.dispatch(Actions.entity_spawn())
	Store.dispatch(Actions.entity_move(0, 2))
	assert_eq(Store.get_state().entities[0].room, 0)
	Store.dispatch(Actions.entity_move(0, 1))
	assert_eq(Store.get_state().entities[0].room, 1)
	Store.dispatch(Actions.entity_move(0, 2))
	assert_eq(Store.get_state().entities[0].room, 2)
	Store.dispatch(Actions.entity_move(0, 0))
	assert_eq(Store.get_state().entities[0].room, 2)
	Store.dispatch(Actions.entity_move(0, 1))
	assert_eq(Store.get_state().entities[0].room, 1)
	Store.dispatch(Actions.entity_move(0, 0))
	assert_eq(Store.get_state().entities[0].room, 0)
