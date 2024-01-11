class_name Audience
extends Node2D


var randomizer = RandomNumberGenerator.new()
var bodies = []
var body_type_count = 6


func _ready():
	randomizer.randomize()
	
	_init_bodies()
	_randomize_body()


func _randomize_body():
	for body in bodies:
		body.visible = false
	
	var selected_body_index: int = randomizer.randi_range(0, body_type_count - 1)
	var position_offset: float = randomizer.randi_range(-1, 1)
	
	bodies[selected_body_index].visible = true
	bodies[selected_body_index].global_position.x += position_offset


func set_wear_color(color: Color):
	for body in bodies:
		body.get_node("Uniform").modulate = color


func decide_wear_color(home_color: Color, away_color: Color):
	var colors = [
		home_color,
		away_color,
	]
	
	var selected_color_index: int = randomizer.randi_range(0, colors.size() - 1)
	var selected_color = colors[selected_color_index]
	selected_color.r += randomizer.randf_range(-0.2, 0.2)
	selected_color.g += randomizer.randf_range(-0.2, 0.2)
	selected_color.b += randomizer.randf_range(-0.2, 0.2)
	
	for body in bodies:
		body.get_node("Uniform").modulate = selected_color


func _init_bodies():
	for i in range(body_type_count):
		bodies.push_back(get_node("Body" + str(i + 1)))
