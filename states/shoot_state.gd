extends Node2D


var stage = null
var current_turn = ""
var anim_done = false


func _on_ball_anim_finished(anim_name):
	if anim_name == "shoot" or anim_name == "miss":
		anim_done = true
		stage.ready_text.visible = true


func _unhandled_input(event):
	if not anim_done:
		return
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			stage.ready_text.visible = false
			anim_done = false
			stage.calculate_results()


func init(s):
	anim_done = false
	
	stage = s
	stage.notice_text.text = ""
	current_turn = stage.current_turn
	
	if not stage.ball.anim.animation_finished.is_connected(_on_ball_anim_finished):
		stage.ball.anim.animation_finished.connect(_on_ball_anim_finished)
	
	stage.keeper.anim.play("shoot")
	stage.shooter.anim.play("shoot")
	stage.ball.anim.play("shoot")
