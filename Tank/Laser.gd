extends Line2D

onready var tween = $Tween
var is_inverted = false

const WIDTH = 10

func _ready():
	# Clear points here so that laser is visible in the editor
	self.clear_points()

func shoot():
	self.add_point(Vector2(0, 0))
	# TODO make laser finite
	self.add_point(Vector2(0, 10 * -128))
	tween.interpolate_property(
		self,
		"width",
		0,
		WIDTH,
		0.1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	
	yield(tween, "tween_completed")
	tween.interpolate_property(
		self,
		"width",
		WIDTH,
		0,
		0.1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()

