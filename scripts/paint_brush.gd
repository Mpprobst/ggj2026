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

var precision = 4

func initialize(_path : BrushPath, data : BrushData, delay):
	path = _path.path
	speed = data.speed #/ 60.0
	width = data.width
	color = data.color
	path_idx = 1
	global_position = path[0]
	last_pos = global_position
	var dir = path[path_idx] - path[path_idx-1]
	set_rot(dir)
	print(global_position)
	print(sprite.offset)
	await get_tree().create_timer(delay).timeout
	
	can_move = true
	
func set_rot(dir):	
	# update sprite rotation based on the dir
	sprite.flip_h = dir.x < 0 or dir.y < 0
	var x = -128
	var y = 64
	if dir.x < 0:
		x = 0
	if dir.y > 0:
		x = 0
	elif dir.y < 0:
		x = 128
		
	if abs(dir.y) > 0.1:
		sprite.rotation = dir.normalized().y * Vector2.RIGHT.angle_to(dir)
	else:
		sprite.rotation = 0
	
	sprite.offset = Vector2(x,y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not can_move:
		return
	var dir = path[path_idx] - path[path_idx-1]
	set_rot(dir)

	global_position = (global_position + dir.normalized() * delta * speed)
	var lastdir = global_position - last_pos
	var pixels = ceil(lastdir.length()) + 1
	
	if pixels >= width / precision / 2:
		last_pos = global_position
		var draw_pos = global_position# - dir.normalized() * width / precision
		var draw_area = Vector2(width/precision, width)
		draw_pos -= Vector2.RIGHT * (width / precision)
		if dir.y > 0:
			draw_pos -= Vector2.UP * (64 + width / precision)
			draw_pos -= Vector2.RIGHT * (128 - width / precision)
		elif dir.y < 0:
			draw_pos -= Vector2.RIGHT * (128 - width / precision)
		if dir.x < 0:
			draw_pos -= Vector2.RIGHT * (128 - width / precision)
		if abs(dir.y) > 0:
			draw_area = Vector2(width,width/precision)
		var rect = Rect2(ceil(draw_pos), draw_area)
		on_paint.emit(rect, color)
		
	var startdir = global_position - path[path_idx-1]
	if startdir.length() >= dir.length():
		path_idx = path_idx + 1
		if path_idx >= path.size():
			print("end of path")
			on_destroy.emit(self)
			queue_free()
		
