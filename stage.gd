extends Node2D


@onready var score_ui = $UI/Score
@onready var results_ui = $UI/Results


func _ready():
	score_ui.match_won.connect(_on_match_won)
	score_ui.show_score()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_W:
			results_ui.show_win_text()
		elif event.keycode == KEY_L:
			results_ui.show_lose_text()
		elif event.keycode == KEY_H:
			results_ui.hide_text()
		elif event.keycode == KEY_X:
			score_ui.add_score(Score.Sides.SIDE_HOME)
		elif event.keycode == KEY_Z:
			score_ui.add_score(Score.Sides.SIDE_HOME, -1)
		elif event.keycode == KEY_C:
			score_ui.add_score(Score.Sides.SIDE_HOME, 5)
		elif event.keycode == KEY_V:
			score_ui.add_score(Score.Sides.SIDE_AWAY)
		elif event.keycode == KEY_B:
			score_ui.add_score(Score.Sides.SIDE_AWAY, -1)
		elif event.keycode == KEY_N:
			score_ui.add_score(Score.Sides.SIDE_AWAY, 5)
		elif event.keycode == KEY_M:
			score_ui.reset_score()


func _on_match_won(_side):
	results_ui.show_win_text()
