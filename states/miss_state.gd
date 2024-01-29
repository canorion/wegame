extends Node2D


var stage = null
var current_turn = ""


func init(s):
	stage = s
	stage.notice_text.text = ""
	current_turn = stage.current_turn
	
	stage.keeper.anim.play("miss")
	stage.shooter.anim.play("miss")
	stage.ball.anim.play("miss")
	
	var anim_name = await stage.ball.anim.animation_finished
	stage.check_result()
