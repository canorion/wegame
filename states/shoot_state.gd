extends Node2D


var stage = null
var current_turn = ""


func init(s):
	stage = s
	stage.notice_text.text = ""
	current_turn = stage.current_turn
	
	stage.keeper.anim.play("shoot")
	stage.shooter.anim.play("shoot")
	stage.ball.anim.play("shoot")
	
	var anim_name = await stage.ball.anim.animation_finished
	
	stage.check_result()
