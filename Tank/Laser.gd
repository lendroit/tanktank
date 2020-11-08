extends Line2D

onready var tween = $Tween
onready var cannonParticles = $CannonParticles
onready var beamParticles = $BeamParticles

const GRID_SIZE = 128
const WIDTH = 10

func _ready():
	# Leave points in the editor then clear points here
	# so that we may visualize the laser in the editor
	self.clear_points()
#	pass

func shoot(length):
	var draw_length = length if length != null else 100
	var draw_world_length = (draw_length - 0.5) * -GRID_SIZE

	self.clear_points()
	self.add_point(Vector2(0, 0))
	self.add_point(Vector2(0, draw_world_length))

	cannonParticles.emitting = true
	beamParticles.emitting = true

	beamParticles.position.y = draw_world_length * 0.5
	beamParticles.process_material.emission_box_extents.x = WIDTH
	beamParticles.process_material.emission_box_extents.y = draw_world_length * 0.5 
	
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
	yield(tween, "tween_completed")
	cannonParticles.emitting = false
	beamParticles.emitting = false

