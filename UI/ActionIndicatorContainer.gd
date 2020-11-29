extends VBoxContainer

export(int, 1, 2) var player_id = 1
onready var action_indicator_container = $PlayerActionIndicator
onready var bullets_container = $Bullets/HBoxContainer
onready var ready_text = $Ready

var bullet_texture_for_player = {
	1: preload("res://Bullets/bulletGreenSilver_outline.png"),
	2: preload("res://Bullets/bulletBlueSilver_outline.png")
}

func _ready():
	ready_text.set("custom_colors/font_color", Constants.PLAYER_COLORS[player_id])
	for action_indicator in action_indicator_container.get_children():
		action_indicator.player_id = player_id

	for child in bullets_container.get_children():
		child.texture = bullet_texture_for_player[player_id]

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

func remove_bullet():
	var children = bullets_container.get_children()
	var nb_children = bullets_container.get_child_count()
	for i in range(nb_children - 1, -1, -1):
		if children[i].visible == true:
			children[i].visible = false
			return

func show_all_bullets():
	for child in bullets_container.get_children():
		child.visible = true
