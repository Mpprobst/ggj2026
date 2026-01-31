extends Node2D

@export var stiffness : float = 0
@export var collision : CollisionPolygon2D
@export var contactPoints : Array[RigidBody2D]
@export var bones : Array[Bone2D]

@onready var area : Area2D = $Area2D
var positions: Array[Vector2]
var selectIdx : int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	positions.resize(len(contactPoints))
	area.input_event.connect(_on_input_event)
	
	for point in contactPoints:
		var springJoints = point.find_children("*", "DampedSpringJoint2D", false)
		for joint in springJoints:
			joint.stiffness = stiffness

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if selectIdx >= 0:
		contactPoints[selectIdx].global_position = mouse_pos
		
	for i in 4:
		positions[i] = contactPoints[i].global_position
		bones[i].global_position = contactPoints[i].global_position
	collision.polygon = positions

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("click " + str(event.position))
			var pos = get_global_mouse_position()
			# get nearest point and start dragging it
			var minDist = 10000
			for i in len(contactPoints):
				var d = contactPoints[i].global_position.distance_to(pos)
				print(str(i) + " -> " + str(d))
				if d < minDist:
					selectIdx = i
					minDist = d
					
			# selected point is too far, don't select
			if minDist > 50:
				selectIdx = -1
		else:
			# release dragged node
			selectIdx = -1

func _on_input_event(viewport, event, shape_idx):
	print(event)
	if event is InputEventMouseButton:# and event.button_index == MOUSE_BUTTON_LEFT:
		print("click " + viewport.name)
