extends Area2D

onready var tween = $Tween

var direction = Vector2.DOWN
var player_id = 1

# TODO align this with Player...
export var speed = 3

# TODO refactor in constants
var tile_size = 64

func custom_init(player_id_param: int, direction_param: Vector2):
	self.direction = direction_param
	self.player_id = player_id_param
	self.rotation = direction_param.angle()

func _ready():
	move_tween()

func move_tween():
	tween.interpolate_property(self, "position",
		position, position + direction * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Bullet_body_entered(body):
	if "player_id" in body && body.player_id == player_id:
		# ignore self collision for animation purposes
		return

	if body && body.has_method("hit"):
		body.hit()

	queue_free()


func _on_Tween_tween_all_completed():
	move_tween()
