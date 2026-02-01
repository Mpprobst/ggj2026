extends Node

@export var levels : Array[LevelData]

@onready var paint_manager : PaintManager = $PaintManager
@onready var player = $PlayerController

@onready var score_panel = $SubViewportContainer/UI/Score

var level_idx : int = 0
var overall_score : float

# Called when the node enters the scene tree for the first time.
func _ready():
	paint_manager.level_complete.connect(on_level_complete)
	
func on_level_complete(score):
	var score_label : Label = score_panel.get_node("Title")
	var next_button : Button = score_panel.get_node("Next")
	score_label.text = "%0.0f" % score + "%"
	print("%0.0f" % score + "%")
	if (score < levels[level_idx].goal_score):
		score_label.modulate = Color.DARK_RED
		next_button.text = "Retry"
	else:
		level_idx += 1 
		score_label.modulate = Color.DARK_GREEN
		next_button.text = "Next"
		overall_score += score

	player.can_draw = false
	
	var tween = create_tween()
	tween.tween_property(score_panel, "position", Vector2(0, score_panel.size.y), 1).set_trans(Tween.TRANS_SPRING)
	
func start_next_level():
	var tween = create_tween()
	tween.tween_property(score_panel, "position", Vector2(0, -score_panel.size.y), 0.5).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	
	if level_idx < levels.size():
		paint_manager.load_level(levels[level_idx])
	else:
		var avg_score = overall_score / levels.size()
		print("game over! %0.0f" % avg_score)
		
		var gameover_panel = $SubViewportContainer/UI/GameOver
		var score_text = gameover_panel.get_node("Score")
		score_text.text = "score: %0.0f" % avg_score + "%"
		tween = create_tween()
		tween.tween_property(gameover_panel, "position", Vector2(0, 0), 1).set_trans(Tween.TRANS_SPRING)
	player.can_draw = true

func start_game():
	var tween = create_tween()
	var game_container = $"SubViewportContainer/UI/Start Game"
	tween.tween_property(game_container, "position", Vector2(0, -512), 1).set_trans(Tween.TRANS_SPRING)
	start_next_level()
	
func restart_game():
	paint_manager.freedraw = false
	var freemode_panel = $SubViewportContainer/UI/FreeMode
	freemode_panel.visible = false
	
	overall_score = 0
	level_idx = 0
	close_end_screen()
	start_next_level()

func close_end_screen():
	var tween = create_tween()
	var gameover_panel = $SubViewportContainer/UI/GameOver
	tween.tween_property(gameover_panel, "position", Vector2(0, -512), 1).set_trans(Tween.TRANS_SPRING)

func freemode():
	paint_manager.freedraw = true
	var freemode_panel = $SubViewportContainer/UI/FreeMode
	freemode_panel.visible = true
	
	paint_manager.canvas.clear_canvas()
	paint_manager.goal_image.texture = null
	
	close_end_screen()

	
