extends Node2D


@onready var audiences = get_children()

var home_color = Color(1, 0, 0)
var away_color = Color(0, 0, 1)
var home_flag_atlas = null
var away_flag_atlas = null
var flags = []

var random = RandomNumberGenerator.new()


func _ready():
	random.randomize()


func initialize(home: Color, away: Color, home_flag, away_flag):
	home_color = home
	away_color = away
	home_flag_atlas = home_flag
	away_flag_atlas = away_flag
	
	_decide_wear_colors()
	
	_put_flags()


func _decide_wear_colors():
		for audience in audiences:
			audience.decide_wear_color(home_color, away_color)


func _put_flags():
	for flag in flags:
		flag.queue_free()
	
	flags.clear()
	
	var flag_count = random.randi_range(1, 2)
	for i in flag_count:
		var flag_type = random.randi_range(0, 1)
		var flag = load("res://match/flag/flag.tscn").instantiate()
		add_child(flag)
		
		if flag_type == 0:
			flag.init_flag(home_flag_atlas)
		else:
			flag.init_flag(away_flag_atlas)
		
		flag.position.x = random.randi_range(-32, 32)
		flag.position.y = random.randi_range(-4, -32)
		var flag_scale_reverse =  random.randi_range(0, 1)
		if flag_scale_reverse == 1:
			flag.scale.x = -1
