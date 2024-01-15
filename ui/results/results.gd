extends Control


@onready var home_win = $Container/HomeWins
@onready var away_win = $Container/AwayWins
@onready var draw_result = $Container/Draw


func init_result(home_logo, away_logo):
	home_win.get_node("CenterContainer/TextureRect").texture = home_logo
	away_win.get_node("CenterContainer/TextureRect").texture = away_logo


func hide_text():
	home_win.visible = false
	away_win.visible = false
	draw_result.visible = false


func show_home_win_text():
	home_win.visible = true
	away_win.visible = false
	draw_result.visible = false


func show_away_win_text():
	home_win.visible = false
	away_win.visible = true
	draw_result.visible = false


func show_draw_text():
	home_win.visible = false
	away_win.visible = false
	draw_result.visible = true
