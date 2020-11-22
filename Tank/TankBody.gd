extends Node2D

onready var rotation_tween = $RotationTween

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
