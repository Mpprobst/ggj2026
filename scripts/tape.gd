class_name Tape extends Node2D

signal on_destroy

@onready var line : Line2D = $Line2D
@onready var button : Button = $Button

func _ready():
	pass#button.position = Vector2.DOWN * line.width

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# TODO: redraw the polygon collision so it may be selected
func update_shape(endpoint):
	line.points[1] = endpoint - global_position
	var dir = line.points[1] - line.points[0]
	var size = Vector2(dir.length(), line.width)
	var angle = Vector2.RIGHT.angle_to(dir)
	button.size = size
	button.rotation = angle

func killme():
	on_destroy.emit(self)
	queue_free()

func _on_button_button_up():
	killme()
