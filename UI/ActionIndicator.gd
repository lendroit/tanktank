extends TextureRect

export(int, 1, 2) var player_id = 1

var active_texture_for_player = {
	1: preload("res://UI/green_boxTick.png"),
	2: preload("res://UI/blue_boxTick.png")
}
var inactive_texture = preload("res://UI/grey_circle.png")

var is_active = false


func enable():
	self.texture = active_texture_for_player[player_id]
	is_active = true
	
func disable():
	self.texture = inactive_texture
	is_active = false
