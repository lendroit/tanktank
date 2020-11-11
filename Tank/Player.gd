extends Area2D

onready var tween = $Tween
onready var front_ray = $FrontRayCast2D
onready var back_ray = $BackRayCast2D

export var speed = 3

signal next_action_starting
signal action_ended

var direction = Direction.ENUM.DOWN

var tile_size = 64
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var action_list

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func start_turn(new_action_list):
	action_list = new_action_list
	exeute_next_action()

func end_of_action():
	emit_signal("action_ended")
	exeute_next_action()

func exeute_next_action():
	var action = action_list.pop_front()
	if action:
		emit_signal("next_action_starting")
		if action == "shoot":
			shoot()
			return
		if action == "left":
			rotate_left()
			return
		if action == "right":
			rotate_right()
			return
		if action == "up":
			moveFrontward()
			return
		if action == "down":

			moveBackward()
			return

func moveFrontward():
	front_ray.force_raycast_update()
	if !front_ray.is_colliding():
		var movement_direction = Direction.VECTORS[direction]
		move_tween(movement_direction)

func moveBackward():
	back_ray.force_raycast_update()
	if !back_ray.is_colliding():
		var opposite_direction = Direction.DIRECTIONS_ORDER[fmod(direction+2, 4)]
		var movement_direction = Direction.VECTORS[opposite_direction]
		move_tween(movement_direction)
	else:
#		animation du tank bloqué
		end_of_action()

func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func shoot():
	$Laser.shoot()

func rotate_left():
	var new_direction = fmod(direction + 3, 4)
	direction = Direction.DIRECTIONS_ORDER[new_direction]
	self.rotate_animate(-PI/2)

func rotate_right():
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

func _on_Tween_tween_all_completed():
	end_of_action()


func _on_Laser_shooting_done():
	end_of_action()

func hit():
	queue_free()
	pass
