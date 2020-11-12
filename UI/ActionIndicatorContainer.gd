extends HBoxContainer

export(int, 1, 2) var player_id = 1

func _ready():
	for action_indicator in get_children():
		action_indicator.player_id = player_id

func add_action():
	for action_indicator in get_children():
		if !action_indicator.is_active:
			action_indicator.enable()
			return

func remove_action():
	for action_indicator in get_children():
		if action_indicator.is_active:
			action_indicator.disable()
			return

func clear_actions():
	for action_indicator in get_children():
		action_indicator.disable()
