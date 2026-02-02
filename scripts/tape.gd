class_name Tape extends Node2D

signal on_destroy

@onready var line : Line2D = $Line2D
@onready var button : Button = $Button

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var rip_clip : AudioStream
@export var drag_loop_clip : AudioStream
@export var crumple_clip : AudioStream

func _ready():
	audio.stream = rip_clip
	audio.play()	
	audio.playing = true
	# not sure why below doesn't work
	#button.position = Vector2.DOWN * line.width / 2
	#button.pivot_offset = Vector2.UP * line.width / 2
	# start looping audio

func length():
	return line.points[0].distance_to(line.points[1])	

func update_shape(endpoint):
	var change = endpoint - global_position - line.points[1]
	if change.length() > 1:
		if not audio.playing:
			audio.stream = drag_loop_clip
			audio.play()
		audio.pitch_scale = 0.9 + change.length() / 200.0
	elif audio.playing:
		audio.stop()
	
	line.points[1] = endpoint - global_position
	var dir = line.points[1] - line.points[0]
	var size = Vector2(dir.length(), line.width)
	var angle = Vector2.RIGHT.angle_to(dir)
	button.size = size
	button.rotation = angle

func killme():
	# crumple audio
	audio.stream = crumple_clip
	audio.pitch_scale = randf_range(0.8, 1.2)

	$Button.visible = false
	audio.play()
	on_destroy.emit(self)
	line.modulate.a = 0
	await audio.finished
	queue_free()

func _on_button_button_up():
	killme()
