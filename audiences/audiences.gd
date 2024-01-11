extends Node2D


@onready var audiences = get_children()
var home_color = Color(1, 0, 0)
var away_color = Color(0, 0, 1)


func init_wear_colors(home: Color, away: Color):
	home_color = home
	away_color = away
	
	_decide_wear_colors()


func _decide_wear_colors():
		for audience in audiences:
			audience.decide_wear_color(home_color, away_color)
