extends Node2D

onready var parent = get_parent()

func _input(event):
	if parent.is_executing_actions:
		return

	if event.is_action_pressed("rotate_right_p1"):
		parent.actions_queue.append(parent.Actions.ROTATE_RIGHT)

	if event.is_action_pressed("rotate_left_p1"):
		parent.actions_queue.append(parent.Actions.ROTATE_LEFT)

	if event.is_action_pressed("move_frontward_p1"):
		parent.actions_queue.append(parent.Actions.MOVE_FRONTWARD)

	if event.is_action_pressed("move_backward_p1"):
		parent.actions_queue.append(parent.Actions.MOVE_BACKWARD)

	if event.is_action_pressed("shoot_p1"):
		parent.actions_queue.append(parent.Actions.SHOOT)

