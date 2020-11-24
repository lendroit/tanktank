extends Node2D

export(NodePath) var tank_path

onready var tank = get_node(tank_path)
onready var rotation_tween = $RotationTween
onready var barrel_sprite = $Barrel
onready var particles = $CannonParticles

var player_id

const barrel_sprites = {
	1: preload("res://Tank/Assets/barrelGreen_outline.png"),
	2: preload("res://Tank/Assets/barrelBlue_outline.png"),
}

func _ready():
	self.player_id = tank.player_id
	barrel_sprite.texture = barrel_sprites[player_id]

func orientate(movement_direction: Vector2):
	# Duplication of TankBody script
	var angle = movement_direction.angle()
	var self_angle = fmod(rotation, 2 * PI)
	var angle_to_add = fmod(angle - self_angle - PI, 2 * PI) + PI

	rotation_tween.interpolate_property(
		self,
		"rotation",
		self.rotation,
		self.rotation + angle_to_add,
		0.1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	rotation_tween.start()
