extends Node

const PLAYER_IDS = [1, 2]
const NUMBER_OF_ACTIONS_PER_TURN = 5

onready var gui: GUI = $CanvasLayer/GUI
onready var game_result_text = $CanvasLayer/GameResultText
onready var world = $World
onready var players = {
	1: $World/Player,
	2: $World/Player2
}

var Bullet = preload("res://Bullets/Bullet.tscn")
var BulletExplosion = preload("res://Bullets/BulletExplosion.tscn")

var players_ready = {
	1: false,
	2: false
}

var players_turn_ongoing = {
	1: false,
	2: false
}

var players_action_ongoing = {
	1: false,
	2: false
}

var players_actions = {
	1: [],
	2: []
}

func _ready():
	players[1].connect("action_ended", self, "_on_Player1_action_ended")
	players[2].connect("action_ended", self, "_on_Player2_action_ended")
	players[1].connect("turn_ended", self, "_on_Player1_turn_ended")
	players[2].connect("turn_ended", self, "_on_Player2_turn_ended")
	players[1].connect("died", self, "_on_Player1_died")
	players[2].connect("died", self, "_on_Player2_died")
	players[1].connect("shoot_bullet", self, "_on_Player1_shot_bullet")
	players[2].connect("shoot_bullet", self, "_on_Player2_shot_bullet")
	players[1].connect("reload", self, "_on_Player1_reloaded")
	players[2].connect("reload", self, "_on_Player2_reloaded")

func _on_Player1_action_ended():
	gui.remove_action(1)
	end_action(1)

func _on_Player2_action_ended():
	gui.remove_action(2)
	end_action(2)

func _on_Player1_turn_ended():
	players_turn_ongoing[1] = false

func _on_Player2_turn_ended():
	players_turn_ongoing[2] = false

func _on_Player2_died():
	game_result_text.player_wins(1)

func _on_Player1_died():
	game_result_text.player_wins(2)

func _on_Player1_shot_bullet(direction):
	player_shoot(1, direction)
	gui.remove_bullet(1)

func _on_Player2_shot_bullet(direction):
	player_shoot(2, direction)
	gui.remove_bullet(2)

func _on_Player1_reloaded():
	gui.show_all_bullets(1)

func _on_Player2_reloaded():
	gui.show_all_bullets(2)

func player_shoot(player_id, direction):
	var new_bullet = Bullet.instance()
	new_bullet.custom_init(self, player_id, direction)
	new_bullet.position = players[player_id].position
	world.add_child(new_bullet)
	new_bullet.connect("died", self, "_on_exploded")

func _on_exploded(position: Vector2):
	var explosion = BulletExplosion.instance()
	explosion.position = position
	explosion.emitting = true
	world.add_child(explosion)

func add_player_action(id: int, action):
	if(players_actions[id].size() >= NUMBER_OF_ACTIONS_PER_TURN):
		return
	players_actions[id].append(action)

	gui.add_action(id)

func are_players_ready():
	return players_ready[1] && players_ready[2]

func is_player_turn_ongoing():
	return players_turn_ongoing[1] || players_turn_ongoing[2]

func is_player_action_ongoing():
	return players_action_ongoing[1] || players_action_ongoing[2]

func _input(event):
	if event.is_action_pressed("restart"):
		var _err = get_tree().reload_current_scene()

	if(is_player_turn_ongoing()):
		return

	for id in PLAYER_IDS:

		# Shooting keys
		if Input.is_action_pressed("shoot_p%s" % id):
			if event.is_action_pressed("rotate_right_p%s" % id):
				add_player_action(id, "shoot_right")

			if event.is_action_pressed("rotate_left_p%s" % id):
				add_player_action(id, "shoot_left")

			if event.is_action_pressed("move_frontward_p%s" % id):
				add_player_action(id, "shoot_up")

			if event.is_action_pressed("move_backward_p%s" % id):
				add_player_action(id, "shoot_down")

		# Movement and other actions
		else:
			if event.is_action_pressed("rotate_right_p%s" % id):
				add_player_action(id, "right")

			if event.is_action_pressed("rotate_left_p%s" % id):
				add_player_action(id, "left")

			if event.is_action_pressed("move_frontward_p%s" % id):
				add_player_action(id, "up")

			if event.is_action_pressed("move_backward_p%s" % id):
				add_player_action(id, "down")

			if event.is_action_pressed("end_turn_p%s" % id):
				players_ready[id] = true
				gui.set_ready(id, true)
				if are_players_ready():
					start_turn()


func start_turn():
	resume_bullet_movement()

	for id in PLAYER_IDS:
		players_ready[id] = false
		gui.set_ready(id, false)
		if players[id]:
			players_turn_ongoing[id] = true
			players_action_ongoing[id] = true
			players[id].start_turn(players_actions[id])

func end_action(player_id):
	players_action_ongoing[player_id] = false
	try_executing_next_action()

func try_executing_next_action():
	if is_player_action_ongoing():
		return
	if !is_player_turn_ongoing():
		return

	resume_bullet_movement()

	for id in PLAYER_IDS:
		if players[id]:
			players_action_ongoing[id] = true
			players[id].execute_next_action()


func resume_bullet_movement():
	var elements = get_tree().get_nodes_in_group("bullets")
	for element in elements:
		if element.has_method("next_action"):
			element.next_action()
