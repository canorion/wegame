class_name Score
extends Control


@onready var score_text = $Container/ScoreText
@onready var anim = $Container/Animation
@onready var home_flag = $Container/HomeFlag/Texture
@onready var away_flag = $Container/AwayFlag/Texture

var scores = {
	"home": 0,
	"away": 0,
}

var score_limit = 2
var current_set = 0


func init_team_logos(home_logo_tex, away_logo_tex):
	home_flag.texture = home_logo_tex
	away_flag.texture = away_logo_tex


func set_score_limit(limit):
	score_limit = 10


func reset_score():
	scores["home"] = 0
	scores["away"] = 0
	
	_update_score()


func set_score(side, score):
	scores[side] = score
	
	_update_score()


func add_score(side, score = 1):
	scores[side] += score
	
	_update_score()


func _update_score():
	var home_score = str(scores["home"])
	var away_score = str(scores["away"])
	
	score_text.text = home_score + " - " + away_score


func show_score():
	anim.play("show")
	var anim_name = await anim.animation_finished
	if anim_name == "show":
		anim.play("visible")


func hide_score():
	anim.play("hide")
	var anim_name = await anim.animation_finished
	if anim_name == "hide":
		anim.play("hidden")
