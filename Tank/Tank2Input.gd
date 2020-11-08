extends Node2D

signal add_action

onready var parent = get_parent()

func _input(event):
	if parent.is_executing_actions:
		return

	if event.is_action_pressed("rotate_right_p2"):
		add_action(parent.Actions.ROTATE_RIGHT)

	if event.is_action_pressed("rotate_left_p2"):
		add_action(parent.Actions.ROTATE_LEFT)

	if event.is_action_pressed("move_frontward_p2"):
		add_action(parent.Actions.MOVE_FRONTWARD)

	if event.is_action_pressed("move_backward_p2"):
		add_action(parent.Actions.MOVE_BACKWARD)

	if event.is_action_pressed("shoot_p2"):
		add_action(parent.Actions.SHOOT)

func add_action(action):
	parent.actions_queue.append(action)
	emit_signal("add_action")
