extends Node2D

@export var tape_prefab : PackedScene
@export var tape_container : Node2D
@export var paint_manager : PaintManager

var drawing : bool
var active_tape : Tape

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
			paint_manager.on_add_tape(active_tape)
			drawing = true
		else:
			drawing = false
	
