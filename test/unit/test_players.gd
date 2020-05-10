extends "res://addons/gut/test.gd"

func before_each():
	Store.create([
		{'name': 'players', 'instance': Reducers},
		{'name': 'ship', 'instance': Reducers},
	])
	Store.dispatch(Actions.ship_load("res://test/resources/test_ship_move.tscn"))

func test_player_spawn():
	Store.dispatch(Actions.player_spawn())
	assert_eq(Store.get_state()['players'][0]['room'], 0)

func test_player_movement():
	Store.dispatch(Actions.player_spawn())
	Store.dispatch(Actions.player_move(0, 2))
	assert_eq(Store.get_state()['players'][0]['room'], 0)
	Store.dispatch(Actions.player_move(0, 1))
	assert_eq(Store.get_state()['players'][0]['room'], 1)
	Store.dispatch(Actions.player_move(0, 2))
	assert_eq(Store.get_state()['players'][0]['room'], 2)
	Store.dispatch(Actions.player_move(0, 0))
	assert_eq(Store.get_state()['players'][0]['room'], 2)
	Store.dispatch(Actions.player_move(0, 1))
	assert_eq(Store.get_state()['players'][0]['room'], 1)
	Store.dispatch(Actions.player_move(0, 0))
	assert_eq(Store.get_state()['players'][0]['room'], 0)
