extends Node2D
class_name Tank

# TODO get this value from a config somewhere
const GRID_SIZE = 128

onready var grid = get_parent()
onready var tween = $Tween
var is_moving = false
var is_rotating = false
var direction = Direction.ENUM.UP

func _input(event):
	var current_position = self.position
	
	if event.is_action_pressed("ui_right"):
		rotate_right()
	
	if event.is_action_pressed("ui_left"):
		rotate_left()
	
	if event.is_action_pressed("ui_up"):
		move_frontward()
	
	if event.is_action_pressed("ui_down"):
		move_backward()
		
	if event.is_action_pressed("ui_accept"):
		grid.shoot(self, Direction.VECTORS[direction])

func move_frontward():
	move(direction)

func move_backward():
	var opposite_direction = Direction.DIRECTIONS_ORDER[fmod(direction+2, 4)]
	move(opposite_direction)


# TODO add types
func move(direction):
	if is_moving:
		return

	var should_move = grid.move_if_possible(self, Direction.VECTORS[direction])

	if should_move:
		is_moving = true
		tween.interpolate_property(
			self,
			"position",
			self.position,
			self.position + Direction.VECTORS[direction] * GRID_SIZE,
			0.2,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tween.start()

func rotate_left():
	var new_direction = fmod(direction + 3, 4)
	print(new_direction)
	direction = Direction.DIRECTIONS_ORDER[new_direction]
	self.rotate_animate(-PI/2)

func rotate_right():
	var new_direction = fmod(direction + 1, 4)
	direction = Direction.DIRECTIONS_ORDER[new_direction]
	self.rotate_animate(PI/2)

func rotate_animate(new_rotation):
	if is_rotating:
		return

	is_rotating = true
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


func _on_Tween_tween_completed(object, key):
	is_moving = false
	is_rotating = false
