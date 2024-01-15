class_name TeamFactory
extends Node


static func get_team_data(team_name):
	var team = team_name.to_lower()
	
	match team:
		"liverpool":
			return Liverpool.new()
		"chelsea":
			return Chelsea.new()
		_:
			return null
