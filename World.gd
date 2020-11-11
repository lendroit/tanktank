extends Node

onready var gui: GUI = $CanvasLayer/GUI
onready var player1 = $World/Player
onready var player2 = $World/Player2

var player_1_ready = false
var player_2_ready = false

var player_1_turn_ongoing = false
var player_2_turn_ongoing = false

var player_1_action = []
var player_2_action = []

func _ready():
	player1.connect("action_ended", self, "_on_Player1_action_ended")
	player2.connect("action_ended", self, "_on_Player2_action_ended")
	player1.connect("turn_ended", self, "_on_Player1_turn_ended")
	player2.connect("turn_ended", self, "_on_Player2_turn_ended")


func _on_Player1_action_ended():
	gui.remove_p1_action()

func _on_Player2_action_ended():
	gui.remove_p2_action()

func _on_Player1_turn_ended():
	player_1_turn_ongoing = false

func _on_Player2_turn_ended():
	player_2_turn_ongoing = false

func add_player_1_action(action):
	if(player_1_action.size() >= 5):
		return
	player_1_action.append(action)
	gui.add_p1_action()

func add_player_2_action(action):
	if(player_2_action.size() >= 5):
		return
	player_2_action.append(action)
	gui.add_p2_action()

func _input(event):
	if(player_1_turn_ongoing || player_2_turn_ongoing):
		return

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
	if player1:
		player_1_turn_ongoing = true
		player1.start_turn(player_1_action)
	if player2:
		player_2_turn_ongoing = true
		player2.start_turn(player_2_action)

