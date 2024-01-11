extends Node2D


@onready var score_ui = $UI/Score
@onready var results_ui = $UI/Results

var sounds = {}

var home_color = Color(1, 0, 0)
var away_color = Color(0, 0, 1)

var home_team_data = null
var away_team_data = null

var home_team_name = ""
var away_team_name = ""

var js_callback_ref = null
var console = null
var window = null
 

func _ready():
	#if not OS.has_feature('JavaScriptBridge'):
	#	return
	
	js_callback_ref = JavaScriptBridge.create_callback(js_callback)
	console = JavaScriptBridge.get_interface("console")
	window = JavaScriptBridge.get_interface("window")
	window.addEventListener('message', js_callback)
	
	_fetch_and_init_team_data()
	
	score_ui.match_won.connect(_on_match_won)
	score_ui.show_score()


func _fetch_and_init_team_data():
	var home_team_name = window.getHomeTeam()
	home_team_data = TeamFactory.get_team_data(home_team_name)
	
	var away_team_name = window.getAwayTeam()
	away_team_data = TeamFactory.get_team_data(away_team_name)
	
	if home_team_data == null or away_team_data == null:
		return false
	
	for i in range(5):
		get_node("Background/Audiences/Audience" + str(i + 1)).init_wear_colors(
				home_team_data.get_wear_colors(),
				away_team_data.get_wear_colors())
	
	$Match/Shooter.init_shooter(home_team_data.get_shooter_atlas())
	$Match/Keeper.init_keeper(away_team_data.get_keeper_atlas())
	$UI/Score.init_team_logos(
			home_team_data.get_logo_atlas(),
			away_team_data.get_logo_atlas())
	
	return true


func _on_match_won(side):
	results_ui.show_win_text()


func js_callback(args):
	pass

