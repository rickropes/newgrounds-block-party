class_name Enums
enum InputState {
	NOTHING, DRAGGING
}

enum ShapeTypes {
	#explodes to launch others
	TRIANGLE,
	#touches others of the same kind and clumps together
	SPIKY_CIRCLE,
	#separates spiky circles when activated
	PENTAGON,
	#what spiky circles become after using a pentagon
	PLAIN_CIRCLE,
	#freezes other shapes (activates sleep mode on the body)
	OCTAGON,
	#unfreezes frozen shapes
	PARALLELOGRAM,
	#slows down other shapes in a circular field
	HEXAGON,
	
	#points shapes
	STAR, # 20 pts
	HEART, # 15 pts
	ROUND_SQUARE, # 10 pts
}
