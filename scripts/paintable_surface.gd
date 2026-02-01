# This is something we can paint on
class_name PaintableSurface extends Node

const GRID_SIZE = 512
@export var painted_tex : Sprite2D

var img : Image
var mask : Image

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_canvas()

func clear_canvas():
	img = Image.create(GRID_SIZE, GRID_SIZE, false, Image.FORMAT_RGBA8)
	painted_tex.texture = ImageTexture.create_from_image(img)
	paint(Rect2(0, 0, 8, 8), Color.RED)
	paint(Rect2(GRID_SIZE-8, 0, 8, 8), Color.RED)
	paint(Rect2(0, GRID_SIZE-8, 8, 8), Color.RED)
	paint(Rect2(GRID_SIZE-8, GRID_SIZE-8, 8, 8), Color.RED)
	
func paint_at_world_pos(world_pos, size, color):
	var offset = (Vector2.ONE * GRID_SIZE - size) / 2
	world_pos += offset
	paint(Rect2(world_pos, size), color)
	
# Applies a rect of color to the canvas
# NOTE: rect and the image are anchored in top left
func paint(rect : Rect2, color):
	var x = rect.size.x
	var y = rect.size.y
	#print("paint at: " + str(rect))
	for i in range(rect.size.x):
		for j in range(rect.size.y):
			x = rect.position.x + i
			y = rect.position.y + j
			if x >= 0 and x < img.get_width() and y >= 0 and y < img.get_height():
				var tint = Color.WHITE
				if mask != null:
					tint = mask.get_pixel(x,y)
				img.set_pixel(x, y, color * tint)
				
	painted_tex.texture.update(img)
	
func set_mask(m):
	mask = m
