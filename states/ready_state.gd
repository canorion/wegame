extends Node2D


@onready var anim = $Animation

var stage = null
var current_turn = ""

var window = null


func _ready():
	if OS.has_feature("web"):
		window = JavaScriptBridge.get_interface("window")
		_start_recording()
	
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
	#var status = {
		#"win": "away",
	#}
	
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var status = {
		"db_level": random.randf_range(0.2, 0.3),
	}
	
	stage.results[current_turn] = status.db_level
	
	stage.check_cycle()


func _start_recording():
	if OS.has_feature("web"):
		window.startRecording()


func _start_periodic():
	if OS.has_feature("web"):
		window.startPeriodic()
