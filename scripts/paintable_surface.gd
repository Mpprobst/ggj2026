# This is something we can paint on
class_name PaintableSurface extends Node

const GRID_SIZE = 512
const BORDER_SIZE = 6
@export var painted_tex : Sprite2D

var img : Image
var mask : Image

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_canvas()

func clear_canvas():
	img = Image.create(GRID_SIZE, GRID_SIZE, false, Image.FORMAT_RGBA8)
	painted_tex.texture = ImageTexture.create_from_image(img)
	var border_color = Color.SADDLE_BROWN
	paint(Rect2(0, 0, GRID_SIZE, BORDER_SIZE), border_color, true)
	paint(Rect2(GRID_SIZE-BORDER_SIZE, 0, BORDER_SIZE, GRID_SIZE), border_color, true)
	paint(Rect2(0, GRID_SIZE-BORDER_SIZE, GRID_SIZE, BORDER_SIZE), border_color, true)
	paint(Rect2(0, 0, BORDER_SIZE, GRID_SIZE), border_color, true)
	
func paint_at_world_pos(world_pos, size, color):
	var offset = (Vector2.ONE * GRID_SIZE - size) / 2
	world_pos += offset
	paint(Rect2(world_pos, size), color)
	
# Applies a rect of color to the canvas
# NOTE: rect and the image are anchored in top left
# borer means we are drawing the border
func paint(rect : Rect2, color, border : bool = false):
	var x = rect.size.x
	var y = rect.size.y
	var border_min = Vector2.ZERO
	var border_max = Vector2.ONE * GRID_SIZE
	if not border:
		border_min = Vector2.ONE * BORDER_SIZE
		border_max = border_max - border_min
	#print("paint at: " + str(rect))
	for i in range(rect.size.x):
		for j in range(rect.size.y):
			x = rect.position.x + i
			y = rect.position.y + j
			if x >= border_min.x and x < border_max.x and y >= border_min.y and y < border_max.y:
				var tint = Color.WHITE
				if mask != null:
					tint = mask.get_pixel(x,y)
				# only write if there is color
				if tint == Color.WHITE:	
					img.set_pixel(x, y, color * tint)
				
	painted_tex.texture.update(img)
	
func set_mask(m):
	mask = m
	
func pixel_count():
	return (GRID_SIZE - BORDER_SIZE) ** 2
