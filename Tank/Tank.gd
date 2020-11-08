extends Node2D
class_name Tank

# TODO get this value from a config somewhere
const GRID_SIZE = 128
export (String) var tank_name

onready var grid = get_parent()
onready var tween = $Tween
var is_moving = false
var is_executing_actions = false
var direction = Direction.ENUM.UP

enum Actions {
	MOVE_FRONTWARD,
	MOVE_BACKWARD,
	ROTATE_RIGHT,
	ROTATE_LEFT,
	SHOOT
}

var actions_queue = []

func _input(event):
	if is_executing_actions:
		return

#TODO Create Tank1 and Tank2 that implements the _input actions
	if self.tank_name == "PLAYER_1":
		if event.is_action_pressed("rotate_right_p1"):
			actions_queue.append(Actions.ROTATE_RIGHT)

		if event.is_action_pressed("rotate_left_p1"):
			actions_queue.append(Actions.ROTATE_LEFT)

		if event.is_action_pressed("move_frontward_p1"):
			actions_queue.append(Actions.MOVE_FRONTWARD)

		if event.is_action_pressed("move_backward_p1"):
			actions_queue.append(Actions.MOVE_BACKWARD)

		if event.is_action_pressed("shoot_p1"):
			actions_queue.append(Actions.SHOOT)


	if self.tank_name == "PLAYER_2":
		if event.is_action_pressed("rotate_right_p2"):
			actions_queue.append(Actions.ROTATE_RIGHT)

		if event.is_action_pressed("rotate_left_p2"):
			actions_queue.append(Actions.ROTATE_LEFT)

		if event.is_action_pressed("move_frontward_p2"):
			actions_queue.append(Actions.MOVE_FRONTWARD)

		if event.is_action_pressed("move_backward_p2"):
			actions_queue.append(Actions.MOVE_BACKWARD)

		if event.is_action_pressed("shoot_p2"):
			actions_queue.append(Actions.SHOOT)


func move_frontward():
	move(direction)

func move_backward():
	var opposite_direction = Direction.DIRECTIONS_ORDER[fmod(direction+2, 4)]
	move(opposite_direction)


# TODO add types
func move(move_direction):
	if is_moving:
		return

	var should_move = grid.move_if_possible(self, Direction.VECTORS[move_direction])

	if should_move:
		is_moving = true
		tween.interpolate_property(
			self,
			"position",
			self.position,
			self.position + Direction.VECTORS[move_direction] * GRID_SIZE,
			0.2,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tween.start()

func rotate_left():
	if is_moving:
		return
	is_moving = true
	
	var new_direction = fmod(direction + 3, 4)
	direction = Direction.DIRECTIONS_ORDER[new_direction]
	self.rotate_animate(-PI/2)

func rotate_right():
	if is_moving:
		return
	is_moving = true
	
	var new_direction = fmod(direction + 1, 4)
	direction = Direction.DIRECTIONS_ORDER[new_direction]
	self.rotate_animate(PI/2)

func rotate_animate(new_rotation):
	tween.interpolate_property(
		self,
		"rotation",
		self.rotation,
		self.rotation + new_rotation,
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()

func shoot():
	grid.shoot(self, Direction.VECTORS[direction])

func _on_Tween_tween_completed(_object, _key):
	is_moving = false

func execute_next_action():
	var action = actions_queue.pop_front()
	if action == null:
		return

	match action:
		Actions.MOVE_BACKWARD:
			move_backward()
		Actions.MOVE_FRONTWARD:
			move_frontward()
		Actions.ROTATE_LEFT:
			rotate_left()
		Actions.ROTATE_RIGHT:
			rotate_right()
		Actions.SHOOT:
			shoot()

