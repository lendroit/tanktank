extends TileMap
class_name Grid

const HEIGHT = 4
const WIDTH = 4

var tank_positions = []

var Tank = preload("res://Tank/Tank.tscn")

func _ready():
	make_grid()
	place_tank(1, 1)
	
	print(tank_positions)

func make_grid():
	for y in HEIGHT:
		var line = []
		for x in WIDTH:
			line.append(null)
		tank_positions.append(line)

func place_tank(x,y):
	var new_tank = Tank.instance()
	
	var world_position = self.map_to_world(Vector2(x, y))
	new_tank.position = world_position
	tank_positions[y][x] = "TANK"
	self.add_child(new_tank)
	

func move_if_possible(tank, direction: Vector2):
	var pos = world_to_map(tank.position)
	var next_pos = Vector2(pos.y + direction.y, pos.x + direction.x)
	if can_move(pos, next_pos):
		tank_positions[pos.y][pos.x] = null
		tank_positions[pos.y + direction.y][pos.x + direction.x] = "TANK"
		
		return true
	return false

func can_move(initial_position: Vector2, next_position: Vector2):
	if next_position.x < 0 || next_position.y <0:
		return false
	if next_position.x >= tank_positions[0].size() || next_position.y >= tank_positions.size():
		return false
	return true
