extends Node2D


@onready var score_ui = $UI/Score
@onready var results_ui = $UI/Results
@onready var notice_text = $UI/NoticeText

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
	
	_start()


func _run_state(state):
	states[state].init(self)


func _start():
	change_state("ready")


func check_cycle():
	if current_turn == "home":
		current_turn = "away"
		$Match/Shooter.init_shooter(away_team_data.get_shooter_atlas())
		$Match/Keeper.init_keeper(home_team_data.get_keeper_atlas())
		change_state("ready")
		
	else:
		current_turn = "home"
		
		if (score_ui.scores.home >= score_ui.score_limit and
				score_ui.scores.away >= score_ui.score_limit):
			results_ui.show_draw_text()
		elif score_ui.scores.home >= score_ui.score_limit:
			results_ui.show_home_win_text()
		elif score_ui.scores.away >= score_ui.score_limit:
			results_ui.show_away_win_text()
		else:
			$Match/Shooter.init_shooter(home_team_data.get_shooter_atlas())
			$Match/Keeper.init_keeper(away_team_data.get_keeper_atlas())
			change_state("ready")


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
	
	for i in range(5):
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
