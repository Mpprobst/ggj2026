extends Node2D

@export var tape_prefab : PackedScene
@export var tape_container : Node2D

var drawing : bool
var active_tape : Tape

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drawing and active_tape != null:
		active_tape.update_shape(get_global_mouse_position())

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var pos = get_global_mouse_position()
			active_tape = tape_prefab.instantiate()
			tape_container.add_child(active_tape)
			active_tape.global_position = pos
			drawing = true
		else:
			# release dragged node
			drawing = false
