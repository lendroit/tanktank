extends TextureRect

var active_texture = preload("res://UI/blue_boxTick.png")
var inactive_texture = preload("res://UI/grey_circle.png")

var is_active = false

# TODO needs a P1/P2 color mode

func enable():
	self.texture = active_texture
	is_active = true
	
func disable():
	self.texture = inactive_texture
	is_active = false
