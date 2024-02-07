extends Node2D


@onready var sprite = $Sprite
@onready var anim = $Animation
@onready var shoot = $Shoot


func init_shooter(tex_path, shoot_tex_path):
	sprite.texture = tex_path
	shoot.texture = shoot_tex_path
