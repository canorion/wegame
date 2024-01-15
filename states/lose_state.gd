extends Node2D


var stage = null
var current_turn = ""

var timer = Timer.new()


func _ready():
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)


func init(s):
	stage = s
	stage.notice_text.text = ""
	current_turn = stage.current_turn
	
	stage.keeper.anim.play("lose")
	stage.shooter.anim.play("lose")
	stage.ball.anim.play("lose")
	
	if current_turn == "home":
		stage.results_ui.show_away_win_text()
	else:
		stage.results_ui.show_home_win_text()
	
	stage.score_ui.show_score()
	await stage.score_ui.anim.animation_finished
	timer.start()
	await timer.timeout
	stage.score_ui.hide_score()
	await stage.score_ui.anim.animation_finished
	stage.results_ui.hide_text()
	
	stage.check_cycle()
