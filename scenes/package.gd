class_name Package extends Node2D

var type = 0

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

func tilt():
	animation_player.play("tilt")
