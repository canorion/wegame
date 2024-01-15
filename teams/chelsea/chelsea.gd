class_name Chelsea
extends Node


func get_flag_atlas():
	var team_atlas = AtlasTexture.new()
	team_atlas.atlas = load("res://teams/chelsea/chelsea.png")
	team_atlas.set_region(Rect2(0, 0, 15, 13))
	
	return team_atlas


func get_keeper_atlas():
	var team_atlas = AtlasTexture.new()
	team_atlas.atlas = load("res://teams/chelsea/chelsea.png")
	team_atlas.set_region(Rect2(76, 0, 30, 45))
	
	return team_atlas


func get_logo_atlas():
	var team_atlas = AtlasTexture.new()
	team_atlas.atlas = load("res://teams/chelsea/chelsea.png")
	team_atlas.set_region(Rect2(46, 0, 29, 37))
	
	return team_atlas


func get_shooter_atlas():
	var team_atlas = AtlasTexture.new()
	team_atlas.atlas = load("res://teams/chelsea/chelsea.png")
	team_atlas.set_region(Rect2(15, 0, 29, 45))
	
	return team_atlas


func get_wear_colors():
	return Color(0, 0, 1)
