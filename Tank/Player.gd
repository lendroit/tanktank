extends KinematicBody2D

onready var body = $TankBody
onready var sprite = $TankBody/Sprite
onready var barrel = $TankBarrel/Barrel
onready var laser = $TankBarrel/Laser
onready var tween = $Tween
onready var tween_bump_obstacle = $TweenBumpObstacle
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
signal shoot_bullet

var shots_left_before_reload = MAX_SHOTS

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
	position = position.snapped(Vector2.ONE * Constants.GRID_SIZE)
	position += Vector2.ONE * Constants.GRID_SIZE/2
	
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
	orientate_tank(movement_direction)
	next_position_collision_shape.position = movement_direction * Constants.GRID_SIZE
	next_position_collision_shape.disabled = false
	yield(get_tree().create_timer(0.1), "timeout")
	next_position_ray.cast_to = movement_direction * Constants.GRID_SIZE
	next_position_ray.force_raycast_update()
	if !next_position_ray.is_colliding():
		move_tween(movement_direction)
	else:
		bump_against_obstacle(movement_direction)
	yield(get_tree().create_timer(0.1), "timeout")
	next_position_collision_shape.disabled = true


func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * Constants.GRID_SIZE,
		Constants.ANIMATION_LENGTH, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func orientate_tank(movement_direction):
	body.orientatebody(movement_direction)
	pass


func shoot():
	if shots_left_before_reload > 0:
		# If you want the laser back
		# laser.shoot()

		# TODO: shoot in direction
		emit_signal("shoot_bullet", Vector2.RIGHT)
		shots_left_before_reload -= 1
		skip_turn()
	else:
		reload()

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
		position, position + movement_direction * Constants.GRID_SIZE * BUMP_FORCE,
		Constants.ANIMATION_LENGTH / 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_bump_obstacle.start()

	yield(tween_bump_obstacle, "tween_completed")

	tween_bump_obstacle.interpolate_property(self, "position",
		position, position - movement_direction * Constants.GRID_SIZE * BUMP_FORCE,
		Constants.ANIMATION_LENGTH / 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_bump_obstacle.start()

	yield(tween_bump_obstacle, "tween_completed")

	end_of_action()

func reload():
	shots_left_before_reload = MAX_SHOTS
	skip_turn()

func skip_turn():
	yield(get_tree().create_timer(Constants.ANIMATION_LENGTH), "timeout")
	end_of_action()
