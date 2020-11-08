class_name Direction

# TODO better naming...
enum ENUM {
	RIGHT,
	DOWN,
	LEFT,
	UP
}

const DIRECTIONS_ORDER = [
	ENUM.RIGHT,
	ENUM.DOWN,
	ENUM.LEFT,
	ENUM.UP
]


const VECTORS = {
	ENUM.RIGHT: Vector2.RIGHT,
	ENUM.DOWN: Vector2.DOWN,
	ENUM.LEFT: Vector2.LEFT,
	ENUM.UP: Vector2.UP
}
