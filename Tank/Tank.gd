extends Node2D

# TODO get this value from a config somewhere
const GRID_SIZE = 128

var grid

class_name Tank

onready var tween = $Tween
var is_moving = false

func _ready():
	grid = get_parent()

func _input(event):
	var current_position = self.position
	
	if event.is_action_pressed("ui_right"):
		move(Direction.ENUM.RIGHT)
	
	if event.is_action_pressed("ui_left"):
		move(Direction.ENUM.LEFT)
	
	if event.is_action_pressed("ui_up"):
		move(Direction.ENUM.UP)
	
	if event.is_action_pressed("ui_down"):
		move(Direction.ENUM.DOWN)
		
	if event.is_action_pressed("ui_accept"):
		grid.shoot(self, Vector2.ZERO)

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


func _on_Tween_tween_completed(object, key):
	is_moving = false
