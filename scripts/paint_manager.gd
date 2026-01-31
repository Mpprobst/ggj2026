class_name PaintManager extends Node2D

# TODO: a texture that we draw to

@export var canvas : PaintableSurface

var tapes : Array[Tape]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		var pos = get_global_mouse_position()
		var size = Vector2(32, 32)
		canvas.paint_at_world_pos(pos, size, Color.RED)
		
func on_add_tape(tape: Tape):
	tape.on_destroy.connect(on_remove_tape)
	tapes.push_front(tape)
	recalculate_mask()
	
func on_remove_tape(tape: Tape):
	tapes.erase(tape)
	recalculate_mask()

func recalculate_mask():
	pass
