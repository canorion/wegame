extends Node2D


@onready var sprite = $Sprite


func _init_flag(tex_path):
	sprite.texture = tex_path
