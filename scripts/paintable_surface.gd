# This is something we can paint on
extends Node

const GRID_SIZE = 512
@export var painted_tex : Sprite2D

var img : Image

# Called when the node enters the scene tree for the first time.
func _ready():
	img = Image.create(GRID_SIZE, GRID_SIZE, false, Image.FORMAT_RGBA8)
	painted_tex.texture = ImageTexture.create_from_image(img)
	
# Applies a rect of color to the canvas
# NOTE: rect and the image are anchored in top left
func apply_color(rect : Rect2, color):
	pass
	var x = rect.size.x
	var y = rect.size.y
	
	for i in range(rect.size.x):
		for j in range(rect.size.y):
			print()
			x = rect.position.x + i
			y = rect.position.y + j
			if x >= 0 and x < img.get_width() and y >= 0 and y < img.get_height():
				img.set_pixel(x, y, color)
				
	painted_tex.texture = ImageTexture.create_from_image(img)
	
