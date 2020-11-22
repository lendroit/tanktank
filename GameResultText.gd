extends Label

func player_wins(id: int):
	self.visible = true
	self.text = "PLAYER %s WINS" % id
	self.set("custom_colors/font_color", Constants.PLAYER_COLORS[id])
