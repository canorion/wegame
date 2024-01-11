extends Node2D


@onready var sprite = $Sprite


func init_shooter(tex_path):
	sprite.texture = tex_path
