extends "res://addons/gut/test.gd"

func before_each():
	Store.create([
		{"name": "game", "instance": Reducers},
		{"name": "players", "instance": Reducers},
	])
	Store.dispatch(Actions.player_connected(1, "Test Player"))

func test_game_start():
	Store.dispatch(Actions.game_start())
	assert_has(Store.get_state().game, "first_player")
