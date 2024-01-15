extends Node2D


@onready var anim = $Animation

var stage = null
var current_turn = ""


func _ready():
	anim.animation_finished.connect(_on_anim_finished)


func init(s):
	stage = s
	stage.notice_text.text = ""
	current_turn = stage.current_turn
	
	anim.play("active")
	
	stage.keeper.anim.play("ready")
	stage.shooter.anim.play("ready")
	stage.ball.anim.play("ready")


func _set_text_get_ready():
	stage.notice_text.text = "Get Ready!"


func _set_text_listen_clap():
	stage.notice_text.text = "Listen Clap!"


func _set_text_your_turn():
	stage.notice_text.text = "Your Turn!"


func _play_music():
	stage.play_sound("music")


func _on_anim_finished(anim_name):
	#WebRequest.request_match_result()
	#var req = await WebRequest.match_result_req.request_completed
	#var status = JSON.parse_string(req[3].get_string_from_utf8())
	var status = {
		"win": "away",
	}
	
	if status.win == current_turn:
		stage.change_state("shoot")
	else:
		stage.change_state("miss")
