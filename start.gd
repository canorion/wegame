extends Node2D


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			get_tree().change_scene_to_file("res://stage.tscn")
