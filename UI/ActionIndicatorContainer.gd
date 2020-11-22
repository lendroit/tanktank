extends VBoxContainer

export(int, 1, 2) var player_id = 1
onready var action_indicator_container = $PlayerActionIndicator
onready var ready_text = $Ready

# TODO refactor these colors with win game
const player_colors = {
	1: Color(94 / 255.0, 177 / 255.0, 94 / 255.0),
	2: Color(30 / 255.0, 167 / 255.0, 255 / 255.0)
}

var player_color = player_colors[player_id]

func _ready():
	ready_text.set("custom_colors/font_color", player_colors[player_id])
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
