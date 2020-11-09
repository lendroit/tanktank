extends Area2D

onready var tween = $Tween
onready var ray = $RayCast2D

export var speed = 3

var tile_size = 64
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var action_list

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	# Adjust animation speed to match movement speed
	$AnimationPlayer.playback_speed = speed

func start_turn(new_action_list):
	action_list = new_action_list
	exeute_next_action()

func exeute_next_action():
	var action = action_list.pop_front()
	if action:
		move(action)

func move(dir):
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		$AnimationPlayer.play(dir)
		move_tween(inputs[dir])
		
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	exeute_next_action()
