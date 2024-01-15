extends Node2D


@onready var sprite = $Sprite
@onready var anim = $Animation


func init_shooter(tex_path):
	sprite.texture = tex_path
