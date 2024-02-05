extends Node2D


@onready var anim = $Animation

var stage = null
var current_turn = ""

var window = null


func _ready():
	#anim.animation_finished.connect(_on_anim_finished)
	
	if not OS.has_feature("web"):
		return
	
	window = JavaScriptBridge.get_interface("window")


func init(s):
	stage = s
	stage.notice_text.text = ""
	current_turn = stage.current_turn
	
	anim.stop(true)
	anim.play("active")
	
	stage.keeper.anim.stop(true)
	stage.shooter.anim.stop(true)
	stage.ball.anim.stop(true)
	
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


#func _on_anim_finished(anim_name):
	#stage.check_cycle()


func _start_recording():
	if OS.has_feature("web"):
		window.startRecording()


func _start_periodic():
	if OS.has_feature("web"):
		window.startPeriodic()
