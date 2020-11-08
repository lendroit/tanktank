extends HBoxContainer

func add_action():
	for action_indicator in get_children():
		if !action_indicator.is_active:
			action_indicator.enable()
			return

func clear_actions():
	for action_indicator in get_children():
		action_indicator.disable()
