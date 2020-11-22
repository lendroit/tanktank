extends VBoxContainer

export(int, 1, 2) var player_id = 1
onready var action_indicator_container = $PlayerActionIndicator
onready var ready_text = $Ready

func _ready():
	ready_text.set("custom_colors/font_color", Constants.PLAYER_COLORS[player_id])
	for action_indicator in action_indicator_container.get_children():
		action_indicator.player_id = player_id

func add_action():
	for action_indicator in action_indicator_container.get_children():
		if !action_indicator.is_active:
			action_indicator.enable()
			return

func remove_action():
	for action_indicator in action_indicator_container.get_children():
		if action_indicator.is_active:
			action_indicator.disable()
			return

func clear_actions():
	for action_indicator in action_indicator_container.get_children():
		action_indicator.disable()

func set_ready(state: bool):
	ready_text.visible = state
