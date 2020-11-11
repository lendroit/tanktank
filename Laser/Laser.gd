extends Line2D

signal shooting_done

onready var tween = $Tween
onready var cannonParticles = $CannonParticles
onready var beamParticles = $BeamParticles

onready var ray_cast_2d = $RayCast2D

const GRID_SIZE = 128
const WIDTH = 10

func _ready():
	# Leave points in the editor then clear points here
	# so that we may visualize the laser in the editor
	self.clear_points()
#	pass

func shoot():
#	var draw_length = 100
#	var draw_world_length = (draw_length - 0.5) * -GRID_SIZE
	
	var cast_point = ray_cast_2d.cast_to
	ray_cast_2d.force_raycast_update()
	var target
	
	if ray_cast_2d.is_colliding():
		cast_point = to_local(ray_cast_2d.get_collision_point())
		target = ray_cast_2d.get_collider()
	
	var draw_world_length = cast_point

	self.clear_points()
	self.add_point(Vector2(0, 0))
	self.add_point(draw_world_length)

	cannonParticles.emitting = true
	beamParticles.emitting = true

	beamParticles.position.y = draw_world_length.y * 0.5
	beamParticles.process_material.emission_box_extents.x = WIDTH
	beamParticles.process_material.emission_box_extents.y = draw_world_length.y * 0.5 
	
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
	target.hit()
	
	emit_signal("shooting_done")

