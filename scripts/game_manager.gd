extends Node

@export var levels : Array[LevelData]

@onready var paint_manager : PaintManager = $PaintManager

var level_idx : int = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	start_next_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: 
# - start levels
# - track brushes, know when they are all dead

func start_next_level():
	level_idx = level_idx + 1
	paint_manager.load_level(levels[level_idx])
