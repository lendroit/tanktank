extends Label

const player_colors = {
	1: Color(94 / 255.0, 177 / 255.0, 94 / 255.0),
	2: Color(30 / 255.0, 167 / 255.0, 255 / 255.0)
}

func player_wins(id: int):
	self.visible = true
	self.text = "PLAYER %s WINS" % id
	self.set("custom_colors/font_color", player_colors[id])
