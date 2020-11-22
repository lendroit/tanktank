extends KinematicBody2D

onready var sprite = $Sprite
onready var barrel = $Barrel
onready var tween = $Tween
onready var tween_bump_obstacle = $TweenBumpObstacle
onready var front_ray = $FrontRayCast2D
onready var back_ray = $BackRayCast2D
onready var next_front_position_collision_shape = $NextFrontPositionCollisionShape
onready var next_rear_position_collision_shape = $NextRearPositionCollisionShape
onready var next_position_ray = $NextPositionRayCast2D
onready var next_position_collision_shape := $NextPositionCollisionShape2D

export(int, 1, 2) var player_id = 1

export var speed = 3

const BUMP_FORCE = 0.4
const MAX_SHOTS = 3

signal next_action_starting
signal turn_ended
signal action_ended
signal died

var direction = Direction.ENUM.DOWN

var shots_left_before_reload = MAX_SHOTS

var tile_size = 64
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var body_sprites = {
	1: preload("res://Tank/Assets/tankGreen_outline.png"),
	2: preload("res://Tank/Assets/tankBlue_outline.png"),
}

var barrel_sprites = {
	1: preload("res://Tank/Assets/barrelGreen_outline.png"),
	2: preload("res://Tank/Assets/barrelBlue_outline.png"),
}

var action_list

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
	sprite.texture = body_sprites[player_id]
	barrel.texture = barrel_sprites[player_id]

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
			move_left()
			return
		if action == "right":
			move_right()
			return
		if action == "up":
			move_up()
			return
		if action == "down":
			move_down()
			return
	else:
		emit_signal("turn_ended")

func move_up():
	var movement_direction = Vector2.UP
	move(movement_direction)

func move_down():
	var movement_direction = Vector2.DOWN
	move(movement_direction)

func move_left():
	var movement_direction = Vector2.LEFT
	move(movement_direction)

func move_right():
	var movement_direction = Vector2.RIGHT
	move(movement_direction)

func move(movement_direction: Vector2):
	next_position_collision_shape.position = movement_direction * tile_size
	next_position_collision_shape.disabled = false
	yield(get_tree().create_timer(0.1), "timeout")
	next_position_ray.cast_to = movement_direction * tile_size
	next_position_ray.force_raycast_update()
	if !next_position_ray.is_colliding():
		move_tween(movement_direction)
	else:
		bump_against_obstacle(movement_direction)
	yield(get_tree().create_timer(0.1), "timeout")
	next_position_collision_shape.disabled = true
	

func moveFrontward():
	next_front_position_collision_shape.disabled = false
	yield(get_tree().create_timer(0.1), "timeout")
	
	var movement_direction = Direction.VECTORS[direction]
	front_ray.force_raycast_update()
	if !front_ray.is_colliding():
		move_tween(movement_direction)
	else:
		bump_against_obstacle(movement_direction)

	yield(get_tree().create_timer(0.1), "timeout")
	next_front_position_collision_shape.disabled = true

func moveBackward():
	next_rear_position_collision_shape.disabled = false
	yield(get_tree().create_timer(0.1), "timeout")

	var opposite_direction = Direction.DIRECTIONS_ORDER[fmod(direction+2, 4)]
	var movement_direction = Direction.VECTORS[opposite_direction]
	back_ray.force_raycast_update()
	if !back_ray.is_colliding():
		move_tween(movement_direction)
	else:
		bump_against_obstacle(movement_direction)

	yield(get_tree().create_timer(0.1), "timeout")
	next_rear_position_collision_shape.disabled = true

func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func shoot():
	if shots_left_before_reload > 0:
		$Laser.shoot()
		shots_left_before_reload -= 1
	else:
		reload()

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
	emit_signal("died")
	queue_free()
	pass

func bump_against_obstacle(movement_direction):
	tween_bump_obstacle.interpolate_property(self, "position",
		position, position + movement_direction * tile_size * BUMP_FORCE,
		# TODO synchronized turn time
		BUMP_FORCE * 1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_bump_obstacle.start()
	
	yield(tween_bump_obstacle, "tween_completed")
	
	tween_bump_obstacle.interpolate_property(self, "position",
		position, position - movement_direction * tile_size * BUMP_FORCE,
		# TODO synchronized turn time
		BUMP_FORCE * 1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_bump_obstacle.start()
	
	yield(tween_bump_obstacle, "tween_completed")
	
	# TODO make sure that animation length corresponds to other animations
	
	end_of_action()

func reload():
	shots_left_before_reload = MAX_SHOTS
	skip_turn()

func skip_turn():
	# TODO synchronized turn time
	yield(get_tree().create_timer(0.3), "timeout")
	end_of_action()
