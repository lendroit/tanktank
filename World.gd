extends Node

const PLAYER_IDS = [1, 2]
const NUMBER_OF_ACTIONS_PER_TURN = 5

onready var gui: GUI = $CanvasLayer/GUI
onready var game_result_text = $CanvasLayer/GameResultText
onready var players = {
	1: $World/Player,
	2: $World/Player2
}

var players_ready = {
	1: false,
	2: false
}

var players_turn_ongoing = {
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


func _on_Player1_action_ended():
	gui.remove_action(1)

func _on_Player2_action_ended():
	gui.remove_action(2)

func _on_Player1_turn_ended():
	players_turn_ongoing[1] = false

func _on_Player2_turn_ended():
	players_turn_ongoing[2] = false

func _on_Player2_died():
	game_result_text.player_wins(1)

func _on_Player1_died():
	game_result_text.player_wins(2)

func add_player_action(id: int, action):
	if(players_actions[id].size() >= NUMBER_OF_ACTIONS_PER_TURN):
		return
	players_actions[id].append(action)
	
	gui.add_action(id)

func are_players_ready():
	return players_ready[1] && players_ready[2]

func is_player_turn_ongoing():
	return players_turn_ongoing[1] || players_turn_ongoing[2]

func _input(event):
	if(is_player_turn_ongoing()):
		return

	for id in PLAYER_IDS:
		if event.is_action_pressed("rotate_right_p%s" % id):
			add_player_action(id, "right")

		if event.is_action_pressed("rotate_left_p%s" % id):
			add_player_action(id, "left")

		if event.is_action_pressed("move_frontward_p%s" % id):
			add_player_action(id, "up")

		if event.is_action_pressed("move_backward_p%s" % id):
			add_player_action(id, "down")

		if event.is_action_pressed("shoot_p%s" % id):
			add_player_action(id, "shoot")

		if event.is_action_pressed("end_turn_p%s" % id):
			players_ready[id] = true
			if are_players_ready():
				start_turn()

func start_turn():
	for id in PLAYER_IDS:
		players_ready[id] = false
		if players[id]:
			players_turn_ongoing[id] = true
			players[id].start_turn(players_actions[id])

