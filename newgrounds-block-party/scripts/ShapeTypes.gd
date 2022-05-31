class_name ShapeTypes 
extends Resource

enum {
	#explodes to launch others
	TRIANGLE,
	#touches others of the same kind and clumps together
	SPIKY_CIRCLE,
	#turns spiky circles to plain circles
	PENTAGON,
	#what spiky circles become after using a pentagon
	PLAIN_CIRCLE,
	#freezes other shapes (activates sleep mode on the body)
	OCTAGON,
	#unfreezes frozen shapes
	PARALLELOGRAM,
	#slows down other shapes in a circular field
	HEXAGON,
	#Turns circles into spiky circles
	SQUARE,
	
	#points shapes
	STAR, # 20 pts
	HEART, # 15 pts
	ROUND_SQUARE, # 10 pts
}
