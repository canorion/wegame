extends Node2D


@onready var anim = $Animation


func _ready():
	anim.current_animation_changed.connect(_on_current_animation_changed)


func _on_current_animation_changed(anim_name):
	if anim_name == "shoot" or anim_name == "miss":
		$Shoot.play()
