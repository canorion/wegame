extends Control


@onready var win_text = $Container/WinText
@onready var lose_text = $Container/LoseText


func hide_text():
	win_text.visible = false
	lose_text.visible = false


func show_win_text():
	win_text.visible = true
	lose_text.visible = false


func show_lose_text():
	win_text.visible = false
	lose_text.visible = true
