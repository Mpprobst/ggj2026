class_name Tape extends Node2D

signal on_destroy

@onready var line : Line2D = $Line2D
@onready var button : Button = $Button

func _ready():
	pass
	# not sure why below doesn't work
	#button.position = Vector2.DOWN * line.width / 2
	#button.pivot_offset = Vector2.UP * line.width / 2
	# start looping audio

func length():
	return line.points[0].distance_to(line.points[1])	

func update_shape(endpoint):
	line.points[1] = endpoint - global_position
	var dir = line.points[1] - line.points[0]
	var size = Vector2(dir.length(), line.width)
	var angle = Vector2.RIGHT.angle_to(dir)
	button.size = size
	button.rotation = angle

func killme():
	# crumple audio
	on_destroy.emit(self)
	queue_free()

func _on_button_button_up():
	killme()
