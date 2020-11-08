extends TileMap
class_name Grid

const HEIGHT = 5
const WIDTH = 8
onready var timer = $ActionExecutionTimer

# TODO add setters for this
var object_positions = []
var number_of_remaining_actions_to_execute_this_turn = 0

const INITIAL_POSITION_PLAYER_1 = Vector2(3, 3)
const INITIAL_POSITION_PLAYER_2 = Vector2(0, 0)

var Tank1 = preload("res://Tank/Tank1.tscn")
var Tank2 = preload("res://Tank/Tank2.tscn")

var player_1_ready = false
var player_2_ready = false

func _ready():
	make_object_positions_grid()
	register_children_objects()
#	TODO create a enum for player names
	place_tank(INITIAL_POSITION_PLAYER_1, "PLAYER_1")
	place_tank(INITIAL_POSITION_PLAYER_2, "PLAYER_2")
	
func register_children_objects():
	var children = self.get_children()

	for child in children:
		if child is Node2D:
			var child_map_position = self.world_to_map(child.position)
			register_object(child_map_position, child)

func _input(event):

	if event.is_action_pressed("end_turn_p1"):
		player_1_ready = true
		if player_1_ready && player_2_ready:
			execute_actions()
	if event.is_action_pressed("end_turn_p2"):
		player_2_ready = true
		if player_1_ready && player_2_ready:
			execute_actions()

func make_object_positions_grid():
	var array = []
	for y in HEIGHT:
		var line = []
		for x in WIDTH:
			line.append(null)
		array.append(line)
	
	object_positions = array

func place_tank(initial_position: Vector2, tank_name: String):
	var new_tank
	if tank_name == "PLAYER_1":
		new_tank = Tank1.instance()
	if tank_name == "PLAYER_2":
		new_tank = Tank2.instance()
	new_tank.tank_name = tank_name
	
	var world_position = self.map_to_world(initial_position)
	new_tank.position = world_position

	register_object(initial_position, new_tank)
	self.add_child(new_tank)
	
func register_object(position: Vector2, object):
	object_positions[position.y][position.x] = object

func move_if_possible(tank, direction: Vector2):
	var pos = world_to_map(tank.position)

	var next_pos = Vector2(pos.x + direction.x, pos.y + direction.y)
	
	if can_move(next_pos):
		object_positions[pos.y][pos.x] = null
		object_positions[pos.y + direction.y][pos.x + direction.x] = tank
		return true

	return false

# TODO document this better: it returns the length of the shoot
func shoot(tank, direction: Vector2):
	var pos = world_to_map(tank.position)
	var step = 1
	while 0 < pos.x + step*direction.x && pos.x + step*direction.x < WIDTH && 0 < pos.y + step*direction.y && pos.y + step*direction.y < HEIGHT:
		var target_position = pos + step*direction
		if object_positions[target_position.y][target_position.x] != null:
			impact_object(target_position)
			return step
		step+=1
	
	return null

func impact_object(position: Vector2):
	var object = object_positions[position.y][position.x]
	object.queue_free()
	object_positions[position.y][position.x] = null

func can_move(next_position: Vector2):
	if next_position.x < 0 || next_position.y <0:
		return false
	if next_position.x >= object_positions[0].size() || next_position.y >= object_positions.size():
		return false
		
	if object_positions[next_position.y][next_position.x] != null:
		return false
		
	return true

func execute_actions():
	number_of_remaining_actions_to_execute_this_turn = 5
	player_1_ready = false
	player_2_ready = false
	timer.start()


func _on_ActionExecutionTimer_timeout():
	number_of_remaining_actions_to_execute_this_turn -= 1
	for row_object in object_positions:
		for object in row_object:
			if(object is Tank):
				object.execute_next_action()

	if number_of_remaining_actions_to_execute_this_turn > 0:
		timer.start()
