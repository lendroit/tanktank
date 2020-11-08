extends TileMap
class_name Grid

const HEIGHT = 5
const WIDTH = 8

# TODO add setters for this
var object_positions = []

const INITIAL_POSITION = Vector2(2, 2)

var Tank = preload("res://Tank/Tank.tscn")

func _ready():
	make_object_positions_grid()
	register_children_objects()
	place_tank(INITIAL_POSITION)
	
func register_children_objects():
	var children = self.get_children()
	for child in children: 
		var child_map_position = self.world_to_map(child.position)
		register_object(child_map_position, child)

func make_object_positions_grid():
	var array = []
	for y in HEIGHT:
		var line = []
		for x in WIDTH:
			line.append(null)
		array.append(line)
	
	object_positions = array

func place_tank(initial_position: Vector2):
	var new_tank = Tank.instance()
	
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
	
func shoot(tank, direction: Vector2):
	var pos = world_to_map(tank.position)
	var step = 1
	while 0 < pos.x + step*direction.x && pos.x + step*direction.x < WIDTH && 0 < pos.y + step*direction.y && pos.y + step*direction.y < HEIGHT:
		var target_position = pos + step*direction
		if object_positions[target_position.y][target_position.x] != null:
			impact_object(target_position)
			return
		step+=1

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
