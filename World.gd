extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var tank1 = $World/Grid/Tank1/Script
onready var tank2 = $World/Grid/Tank2/Script
onready var grid = $World/Grid

# Called when the node enters the scene tree for the first time.
func _ready():
	tank1.connect("add_action", $GUI, "add_p1_action")
	tank2.connect("add_action", $GUI, "add_p2_action")
	grid.connect("execute_actions", $GUI, "clear_actions")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
