class_name Score
extends Control


signal match_won(side)

enum Sides {
	SIDE_HOME,
	SIDE_AWAY,
}

@onready var score_text = $Container/ScoreText
@onready var anim = $Container/Animation
@onready var home_flag = $Container/HomeFlag/Texture
@onready var away_flag = $Container/AwayFlag/Texture

var scores = {
	Sides.SIDE_HOME: 0,
	Sides.SIDE_AWAY: 0,
}

var score_limit = 10


func init_team_logos(home_logo_tex, away_logo_tex):
	home_flag.texture = home_logo_tex
	away_flag.texture = away_logo_tex


func set_score_limit(limit):
	score_limit = 10


func reset_score():
	scores[Sides.SIDE_HOME] = 0
	scores[Sides.SIDE_AWAY] = 0
	
	_update_score()


func set_score(side, score):
	scores[side] = score
	
	_check_if_won()
	_update_score()


func add_score(side, score = 1):
	scores[side] += score
	
	_check_if_won()
	_update_score()


func _check_if_won():
	if scores[Sides.SIDE_HOME] >= score_limit:
		match_won.emit(Sides.SIDE_HOME)
	elif scores[Sides.SIDE_AWAY] >= score_limit:
		match_won.emit(Sides.SIDE_AWAY)


func _update_score():
	var home_score = str(scores[Sides.SIDE_HOME])
	var away_score = str(scores[Sides.SIDE_AWAY])
	
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
