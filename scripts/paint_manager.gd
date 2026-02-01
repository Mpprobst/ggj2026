class_name PaintManager extends Node2D

@export var canvas : PaintableSurface
@export var viewport_mask : SubViewport
@export var brush_prefab : PackedScene
@export var goal_image : Sprite2D
@export var brush_container : Node

signal level_complete

var tapes : Array[Tape]
var brushes : Array[PaintBrush]

func load_level(leveldata):
	for i in leveldata.brushes.size():
		var brush = brush_prefab.instantiate() as PaintBrush
		brush_container.add_child(brush)
		brushes.push_front(brush)
		brush.on_paint.connect(canvas.paint)
		brush.on_destroy.connect(on_brush_end)
		brush.initialize(leveldata.paths[i], leveldata.brushes[i])
	goal_image.texture = leveldata.goal
	canvas.clear_canvas()
	recalculate_mask()
		
func on_brush_end(brush):
	brushes.erase(brush)
	if brushes.size() <= 0:
		if tapes.size() == 0:
			calculate_score()
		else:
			print("please peel the tape")
			
func on_add_tape(tape: Tape):
	tape.on_destroy.connect(on_remove_tape)
	tapes.push_front(tape)
	recalculate_mask()
	
func on_remove_tape(tape: Tape):
	tapes.erase(tape)
	if brushes.size() > 0:
		recalculate_mask()
	elif tapes.size() <= 0:
		print("finish")
		calculate_score()

func recalculate_mask():
	RenderingServer.frame_post_draw.connect(get_mask)
	
func get_mask():
	var mask = viewport_mask.get_texture().get_image()
	for y in range(mask.get_height()):
		for x in range(mask.get_width()):
			var color: Color = mask.get_pixel(x, y)
			color.r = 1.0 - color.r
			color.g = 1.0 - color.g
			color.b = 1.0 - color.b
			color.a = 1.0 - color.a
			mask.set_pixel(x, y, color)

	canvas.set_mask(mask)
	
	#var save_path = "C:/Users/mppro/Documents/Projects/ggj2026/test_mask.png"
	#var error = mask.save_png(save_path)
	print("set mask")	
	RenderingServer.frame_post_draw.disconnect(get_mask)
	
func calculate_score():
	var ct = 0
	var raw = goal_image.texture.get_image()
	for x in canvas.img.get_width():
		for y in canvas.img.get_height():
			var c1 = canvas.img.get_pixel(x,y)
			if c1.a == 0:
				c1 = Color.WHITE
			var c2 = raw.get_pixel(x, y)
			var diff = c1.r - c2.r + c1.g - c2.g + c1.b - c2.b
			if abs(diff) < 0.1:
				ct += 1
	var goal_ct = raw.get_width() * raw.get_height()
	var percent = float(ct) / float(goal_ct) * 100.0
	level_complete.emit(percent)
