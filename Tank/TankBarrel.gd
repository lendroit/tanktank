extends Node2D

onready var rotation_tween = $RotationTween

func orientate_barrel(movement_direction: Vector2):
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
