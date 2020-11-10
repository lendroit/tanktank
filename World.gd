extends Node

onready var gui: GUI = $GUI
onready var player1 = $World/Player
onready var player2 = $World/Player2

var player_1_ready = false
var player_2_ready = false

var player_1_action = []
var player_2_action = []

func add_player_1_action(action):
	player_1_action.append(action)
	gui.add_p1_action()

func add_player_2_action(action):
	player_2_action.append(action)
	gui.add_p2_action()

func _input(event):
	if event.is_action_pressed("rotate_right_p1"):
		add_player_1_action("right")

	if event.is_action_pressed("rotate_left_p1"):
		add_player_1_action("left")

	if event.is_action_pressed("move_frontward_p1"):
		add_player_1_action("up")

	if event.is_action_pressed("move_backward_p1"):
		add_player_1_action("down")

	if event.is_action_pressed("shoot_p1"):
		add_player_1_action("shoot")

	if event.is_action_pressed("rotate_right_p2"):
		add_player_2_action("right")

	if event.is_action_pressed("rotate_left_p2"):
		add_player_2_action("left")

	if event.is_action_pressed("move_frontward_p2"):
		add_player_2_action("up")

	if event.is_action_pressed("move_backward_p2"):
		add_player_2_action("down")

	if event.is_action_pressed("shoot_p2"):
		add_player_2_action("shoot")

	if event.is_action_pressed("end_turn_p1"):
		player_1_ready = true
		if player_1_ready && player_2_ready:
			start_turn()
	if event.is_action_pressed("end_turn_p2"):
		player_2_ready = true
		if player_1_ready && player_2_ready:
			start_turn()

func start_turn():
	player_1_ready = false
	player_2_ready = false
	player1.start_turn(player_1_action)
	player2.start_turn(player_2_action)
	gui.clear_actions()