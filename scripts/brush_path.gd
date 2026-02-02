extends Resource
class_name BrushPath

# path is from top right of brush rect
# go all the way to the right but rotate so we stay in bounds
# when going left, don't go all the way left (unless from spawn)
@export var path : Array[Vector2]
