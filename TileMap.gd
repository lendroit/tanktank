extends TileMap
class_name Grid

const HEIGHT = 5
const WIDTH = 8

var object_positions = []


var Tank = preload("res://Tank/Tank.tscn")

func _ready():
	object_positions = make_grid()
	register_children_objects()	
	place_tank(1, 1)
	print(object_positions)
	
func register_children_objects():
	var children = self.get_children()
	print(children)
	for child in children: 
		var child_map_position = self.world_to_map(child.position)
		register_object(child_map_position.x, child_map_position.y, child.type)

func make_grid():
	var array = []
	for y in HEIGHT:
		var line = []
		for x in WIDTH:
			line.append(null)
		array.append(line)
	
	return array



func place_tank(x,y):
	var new_tank = Tank.instance()
	
	var world_position = self.map_to_world(Vector2(x, y))
	new_tank.position = world_position

	register_object(x,y,"TANK")
	self.add_child(new_tank)
	
func register_object(x,y,object):
	object_positions[y][x] = object

func move_if_possible(tank, direction: Vector2):
	var pos = world_to_map(tank.position)
	var next_pos = Vector2(pos.x + direction.x, pos.y + direction.y)
	if can_move(pos, next_pos):
		object_positions[pos.y][pos.x] = null
		object_positions[pos.y + direction.y][pos.x + direction.x] = "TANK"
		
		return true
	return false

func can_move(initial_position: Vector2, next_position: Vector2):
	if next_position.x < 0 || next_position.y <0:
		return false
	if next_position.x >= object_positions[0].size() || next_position.y >= object_positions.size():
		return false
		
	if object_positions[next_position.y][next_position.x] != null:
		return false
		
	return true
