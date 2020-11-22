extends MarginContainer
class_name GUI

onready var player_action_indicator_container = {
	1: $Container/P1ActionIndicator,
	2: $Container/P2ActionIndicator,
}

func clear_actions():
	player_action_indicator_container[1].clear_actions()
	player_action_indicator_container[2].clear_actions()

func add_action(player_id: int):
	player_action_indicator_container[player_id].add_action()

func remove_action(player_id: int):
	player_action_indicator_container[player_id].remove_action()

func set_ready(player_id: int, state: bool):
	player_action_indicator_container[player_id].set_ready(state)
