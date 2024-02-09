extends Node2D


@onready var score_ui = $UI/Score
@onready var results_ui = $UI/Results
@onready var notice_text = $UI/NoticeText
@onready var audio_progress = $UI/AudioProgress/Progress
@onready var ready_text = $UI/ReadyText

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
	"home": -1,
	"away": -1,
}

var current_turn = "home"
var current_shooter = "home"

@onready var states = {
	"ready": $States/Ready,
	"shoot": $States/Shoot,
	"miss": $States/Miss,
	"win": $States/Win,
	"lose": $States/Lose,
}

var is_started = false
var window = null


func _ready():
	if not _fetch_and_init_team_data():
		return
	
	window = JavaScriptBridge.get_interface("window")
	window.startVolumeterAnalyze()
	
	WebListener.js_message_arrived.connect(_on_js_message_arrived)


func _unhandled_input(event):
	if is_started:
		return
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			is_started = true
			_start()


func _on_js_message_arrived(msg_dict):
	if msg_dict.message == "db_level_update":
		_update_audio_progress_value(msg_dict.value)
	elif msg_dict.message == "db_level":
		check_cycle(msg_dict.value)


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


func get_other_side(value):
	if value == "home":
		return "away"
	else:
		return "home"


func check_cycle(value):
	results[current_turn] = value
	
	#var r = RandomNumberGenerator.new()
	#r.randomize()
	#results[current_turn] = r.randf_range(0, 1)
	
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
		
		if results[current_shooter] > results[get_other_side(current_shooter)]:
			score_ui.add_score(current_shooter)
			change_state("shoot")
		elif results[current_shooter] < results[get_other_side(current_shooter)]:
			change_state("miss")
		else:
			change_state("miss")
			#calculate_results()


func calculate_results():
	if score_ui.current_set >= score_ui.score_limit - 1:
		check_result()
	else:
		score_ui.current_set += 1
		current_shooter = get_other_side(current_shooter)
		change_state("ready")
		get_node("UI/Score/Container/HomePointer").visible = true
		get_node("UI/Score/Container/HomePointer/Animation").play("active")
		
		if current_shooter == "home":
			$Match/Shooter.init_shooter(
				home_team_data.get_shooter_atlas(),
				home_team_data.get_shooter_shoot_atlas()
			)
			$Match/Keeper.init_keeper(away_team_data.get_keeper_atlas())
		else:
			$Match/Shooter.init_shooter(
				away_team_data.get_shooter_atlas(),
				away_team_data.get_shooter_shoot_atlas()
			)
			$Match/Keeper.init_keeper(home_team_data.get_keeper_atlas())
		
		results["home"] = -1
		results["away"] = -1


func check_result():
	#if results["home"] == -1 or results["away"] == -1:
		#change_state("ready")
		#if current_turn == "home":
			#get_node("UI/Score/Container/AwayPointer").visible = true
			#get_node("UI/Score/Container/AwayPointer/Animation").play("active")
		#else:
			#get_node("UI/Score/Container/HomePointer").visible = true
			#get_node("UI/Score/Container/HomePointer/Animation").play("active")
		#
		#return
	
	if score_ui.scores.home > score_ui.scores.away:
		results_ui.show_home_win_text()
		notice_text.text = ""
	elif score_ui.scores.away > score_ui.scores.home:
		results_ui.show_away_win_text()
		notice_text.text = ""
	else:
		results_ui.show_draw_text()
		notice_text.text = ""
	
	#if score_ui.scores.home >= score_ui.score_limit:
		#results_ui.show_home_win_text()
	#elif score_ui.scores.away >= score_ui.score_limit:
		#results_ui.show_away_win_text()
	#else:
		#change_state("ready")
		#
		#get_node("UI/Score/Container/HomePointer").visible = true
		#get_node("UI/Score/Container/HomePointer/Animation").play("active")
	#
	#results["home"] = -1
	#results["away"] = -1


func change_state(state):
	_run_state(state)


func play_sound(sound):
	sounds[sound].play()


func _fetch_and_init_team_data():
	#WebRequest.request_team_init()
	#var req = await WebRequest.team_init_req.request_completed
	#var teams = JSON.parse_string(req[3].get_string_from_utf8())
	
	var window = JavaScriptBridge.get_interface("window")
	
	var teams = {
		"home_team_name": window.getHomeTeam(),
		"away_team_name": window.getAwayTeam(),
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
	
	$Match/Shooter.init_shooter(
		home_team_data.get_shooter_atlas(),
		home_team_data.get_shooter_shoot_atlas()
	)
	$Match/Keeper.init_keeper(away_team_data.get_keeper_atlas())
	$UI/Score.init_team_logos(
			home_team_data.get_logo_atlas(),
			away_team_data.get_logo_atlas())
	
	$UI/Results.init_result(
			home_team_data.get_logo_atlas(),
			away_team_data.get_logo_atlas())
	
	return true
