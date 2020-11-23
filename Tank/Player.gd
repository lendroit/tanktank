extends KinematicBody2D

onready var body = $TankBody
onready var barrel = $TankBarrel
onready var sprite = $TankBody/Sprite
onready var barrel_sprite = $TankBarrel/Barrel
onready var barrel_particles = $TankBarrel/CannonParticles
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
	barrel_sprite.texture = barrel_sprites[player_id]

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
		if action == "shoot_right":
			shoot(Vector2.RIGHT)
			return
		if action == "shoot_left":
			shoot(Vector2.LEFT)
			return
		if action == "shoot_up":
			shoot(Vector2.UP)
			return
		if action == "shoot_down":
			shoot(Vector2.DOWN)
			return
		if action == "left":
			move(Vector2.LEFT)
			return
		if action == "right":
			move(Vector2.RIGHT)
			return
		if action == "up":
			move(Vector2.UP)
			return
		if action == "down":
			move(Vector2.DOWN)
			return
	else:
		emit_signal("turn_ended")

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


func shoot(direction: Vector2):
	if shots_left_before_reload > 0:
		# If you want the laser back
		# laser.shoot()

		emit_signal("shoot_bullet", direction)
		shots_left_before_reload -= 1
		rotate_barrel(direction)
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

func rotate_barrel(direction: Vector2):
	barrel.orientate_barrel(direction)
	barrel_particles.emitting = true
	# We don't wait for the barrel to precisely finish to animate
	# we just wait with a given time instead... but this is a little fragile
	# TODO do a regular signal exposed from the barrel body
	# once clock tick refactoring is done
	skip_turn()
