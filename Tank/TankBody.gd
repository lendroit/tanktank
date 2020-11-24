extends Node2D

export(NodePath) var tank_path

onready var rotation_tween = $RotationTween
onready var tank = get_node(tank_path)
onready var sprite = $Sprite

var player_id

const body_sprites = {
	1: preload("res://Tank/Assets/tankGreen_outline.png"),
	2: preload("res://Tank/Assets/tankBlue_outline.png"),
}

func _ready():
	self.player_id = tank.player_id
	sprite.texture = body_sprites[player_id]

func orientatebody(movement_direction: Vector2):
	var angle = movement_direction.angle()
	var self_angle = fmod(rotation, 2 * PI)
	var angle_to_add = fmod(angle - self_angle - PI, 2 * PI) + PI
	rotation_tween.interpolate_property(	
		self,	
		"rotation",	
		self.rotation,	
		self.rotation + angle_to_add,	
		0.2,	
		Tween.TRANS_LINEAR,	
		Tween.EASE_IN_OUT	
	)	
	rotation_tween.start()
