extends Area2D

onready var tween = $Tween
onready var trailing_smoke_particles = $TrailingSmoke
onready var sprite = $SpriteContainer/Sprite

var direction = Vector2.DOWN
var player_id = 1
var world = null

signal died

const bullet_sprites = {
	1: preload("res://Bullets/bulletGreenSilver_outline.png"),
	2: preload("res://Bullets/bulletBlueSilver_outline.png"),
}

func custom_init(world_param, player_id_param: int, direction_param: Vector2):
	self.direction = direction_param
	self.player_id = player_id_param
	self.rotation = direction_param.angle()
	self.world = world_param

func _ready():
	move_tween()
	start_emitting_particles()
	sprite.texture = bullet_sprites[player_id]

func move_tween():
	tween.interpolate_property(self, "position",
		position, position + direction * Constants.GRID_SIZE,
		Constants.ANIMATION_LENGTH, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Bullet_body_entered(body):
	if "player_id" in body && body.player_id == player_id:
		# ignore self collision for animation purposes
		return

	if body && body.has_method("hit"):
		body.hit()
	
	destroy_bullet()

func destroy_bullet():
	emit_signal("died", self.position)
	queue_free()

func _on_Tween_tween_all_completed():
	if world.is_player_turn_ongoing():
		resume_movement()

func resume_movement():
	move_tween()

func start_emitting_particles():
	yield(get_tree().create_timer(0.2), "timeout")
	trailing_smoke_particles.emitting = true
