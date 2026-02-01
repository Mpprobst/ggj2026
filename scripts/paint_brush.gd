class_name PaintBrush extends Node2D

@onready var sprite : Sprite2D = $Sprite2D

signal on_paint
signal on_destroy

var path : Array[Vector2]
var speed : float
var width : float
var color : Color

var path_idx : int

var last_pos : Vector2

func initialize(_path : BrushPath, data : BrushData):
	path = _path.path
	speed = data.speed #/ 60.0
	width = data.width
	color = data.color
	path_idx = 1
	global_position = path[0]
	last_pos = global_position
	print("brush spawned!")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = (path[path_idx] - path[path_idx-1]).normalized()
	global_position = (global_position + dir * delta * speed).clamp(Vector2.ZERO, Vector2.ONE * (512+width))
	var lastdir = global_position - last_pos
	var pixels = ceil(lastdir.length()) + 1
	var go_next = global_position.distance_to(path[path_idx]) < 1
	if pixels >= width / 2 or go_next:
		last_pos = global_position
		var draw_pos = global_position + sprite.offset - Vector2.ONE * width / 2 
		var rect = Rect2(draw_pos, Vector2.ONE * width)
		on_paint.emit(rect, color)
		
	# if at the path idx, go to next
	#print(global_position)
	if global_position.distance_to(path[path_idx]) < 1:
		path_idx = path_idx + 1
		if path_idx >= path.size():
			print("end of path")
			on_destroy.emit(self)
			queue_free()
		
