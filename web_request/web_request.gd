extends Node


@onready var team_init_req = $TeamInit
@onready var match_result_req = $MatchResult

var team_init_req_url = ""
var match_result_req_url = ""


func request_team_init():
	team_init_req.request(team_init_req_url)


func request_match_result():
	match_result_req.request(match_result_req_url)
