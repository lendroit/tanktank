extends Line2D

onready var tween = $Tween

const GRID_SIZE = 128
const WIDTH = 10

func _ready():
	# Leave points in the editor then clear points here
	# so that we may visualize the laser in the editor
	self.clear_points()

func shoot(length):
	var draw_length = length if length != null else 100

	self.add_point(Vector2(0, 0))
	self.add_point(Vector2(0, (draw_length - 0.5) * -GRID_SIZE))
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

