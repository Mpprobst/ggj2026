class_name Tape extends Node2D

@onready var line : Line2D = $Line2D
@onready var collision : CollisionPolygon2D = $Area2D/CollisionPolygon2D

var polygon : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready():
	polygon.resize(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# TODO: redraw the polygon collision so it may be selected
func update_shape(endpoint):
	line.points[1] = endpoint - global_position
	var dir = line.points[1] - line.points[0]
	var perpendicular = Vector2.RIGHT * line.width / 2.0
	polygon[0] = line.points[0] + perpendicular
	polygon[1] = line.points[0] - perpendicular
	polygon[2] = line.points[1] - perpendicular
	polygon[3] = line.points[1] + perpendicular
	collision.polygon = polygon
	
# TODO: use this to remove the tape
func _on_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		queue_free()
