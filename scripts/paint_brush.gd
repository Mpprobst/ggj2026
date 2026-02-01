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
var can_move : bool

func initialize(_path : BrushPath, data : BrushData, delay):
	path = _path.path
	speed = data.speed #/ 60.0
	width = data.width
	color = data.color
	path_idx = 1
	global_position = path[0]
	last_pos = global_position
	
	await get_tree().create_timer(delay).timeout
	
	can_move = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not can_move:
		return
		
	var dir = path[path_idx] - path[path_idx-1]
	global_position = (global_position + dir.normalized() * delta * speed)#.clamp(Vector2.ZERO, Vector2.ONE * (512+width))
	var lastdir = global_position - last_pos
	var pixels = ceil(lastdir.length()) + 1
	if pixels >= width / 2:
		last_pos = global_position
		var draw_pos = global_position + sprite.offset - Vector2.ONE * width / 2 
		var rect = Rect2(draw_pos, Vector2.ONE * width)
		on_paint.emit(rect, color)
		
	var startdir = global_position - path[path_idx-1]
	if startdir.length() >= dir.length():
		path_idx = path_idx + 1
		if path_idx >= path.size():
			print("end of path")
			on_destroy.emit(self)
			queue_free()
		
