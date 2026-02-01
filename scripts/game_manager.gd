extends Node

@export var levels : Array[LevelData]

@onready var paint_manager : PaintManager = $PaintManager

var level_idx : int = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	start_next_level()
	paint_manager.level_complete.connect(on_level_complete)
	
func on_level_complete(score):
	print(score)
	if (score < levels[level_idx].goal_score):
		print("level failed!")
		level_idx -= 1
			
	start_next_level()

func start_next_level():
	level_idx = level_idx + 1
	if level_idx < levels.size():
		paint_manager.load_level(levels[level_idx])
	else:
		print("game over!")
