extends Node2D


@onready var score_ui = $UI/Score
@onready var results_ui = $UI/Results
@onready var notice_text = $UI/NoticeText
@onready var audio_progress = $UI/AudioProgress

@onready var sounds = {
	"hold": $Sound/Hold,
	"kick": $Sound/Kick,
	"music": $Sound/Music,
	"out": $Sound/Out,
}

@onready var keeper = $Match/Keeper
@onready var shooter = $Match/Shooter
@onready var ball = $Match/Ball

var home_team_data = null
var away_team_data = null

var home_team_name = ""
var away_team_name = ""

var results = {
	"home": 0,
	"away": 0,
}

var current_turn = "home"

@onready var states = {
	"ready": $States/Ready,
	"shoot": $States/Shoot,
	"miss": $States/Miss,
	"win": $States/Win,
	"lose": $States/Lose,
}


func _ready():
	if not _fetch_and_init_team_data():
		return
	
	WebListener.js_message_arrived.connect(_on_js_message_arrived)


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			_start()


func _on_js_message_arrived(msg_dict):
	if msg_dict.message == "db_level":
		_update_audio_progress_value(msg_dict.value)


func _update_audio_progress_value(value):
	audio_progress.value = value


func _run_state(state):
	states[state].init(self)


func _start():
	$Theme.stop()
	$UI/StartText.visible = false
	
	score_ui.show_score()
	
	get_node("UI/Score/Container/HomePointer").visible = true
	get_node("UI/Score/Container/HomePointer/Animation").play("active")
	
	$UI/NoticeText.visible = true
	
	change_state("ready")


func check_cycle():
	if current_turn == "home":
		current_turn = "away"
		
		get_node("UI/Score/Container/HomePointer").visible = false
		get_node("UI/Score/Container/AwayPointer").visible = true
		get_node("UI/Score/Container/AwayPointer/Animation").play("active")
		
		change_state("ready")
		
	else:
		current_turn = "home"
		
		get_node("UI/Score/Container/HomePointer").visible = false
		get_node("UI/Score/Container/AwayPointer").visible = false
		
		if results.home > results.away:
			score_ui.add_score("home")
			change_state("shoot")
		elif results.home < results.away:
			score_ui.add_score("away")
			change_state("miss")


func check_result():
	if score_ui.scores.home >= score_ui.score_limit:
		results_ui.show_home_win_text()
	elif score_ui.scores.away >= score_ui.score_limit:
		results_ui.show_away_win_text()
	else:
		change_state("ready")
		
		get_node("UI/Score/Container/HomePointer").visible = true
		get_node("UI/Score/Container/HomePointer/Animation").play("active")


func change_state(state):
	_run_state(state)


func play_sound(sound):
	sounds[sound].play()


func _fetch_and_init_team_data():
	#WebRequest.request_team_init()
	#var req = await WebRequest.team_init_req.request_completed
	#var teams = JSON.parse_string(req[3].get_string_from_utf8())
	
	var teams = {
		"home_team_name": "liverpool",
		"away_team_name": "chelsea",
	}
	
	var home_team_name = teams.home_team_name
	home_team_data = TeamFactory.get_team_data(home_team_name)
	
	var away_team_name = teams.away_team_name
	away_team_data = TeamFactory.get_team_data(away_team_name)
	
	if home_team_data == null or away_team_data == null:
		return false
	
	var audience_count = get_node("Background/Audiences").get_child_count()
	
	for i in audience_count:
		get_node("Background/Audiences/Audience" + str(i + 1)).initialize(
				home_team_data.get_wear_colors(),
				away_team_data.get_wear_colors(),
				home_team_data.get_flag_atlas(),
				away_team_data.get_flag_atlas())
	
	$Match/Shooter.init_shooter(home_team_data.get_shooter_atlas())
	$Match/Keeper.init_keeper(away_team_data.get_keeper_atlas())
	$UI/Score.init_team_logos(
			home_team_data.get_logo_atlas(),
			away_team_data.get_logo_atlas())
	
	$UI/Results.init_result(
			home_team_data.get_logo_atlas(),
			away_team_data.get_logo_atlas())
	
	return true
