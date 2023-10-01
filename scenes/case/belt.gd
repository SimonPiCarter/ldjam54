class_name Belt extends Node2D

@export var next : Belt = null
@export var rotate = false
@export var down = false

@export var package : Package = null
# package from current progress call (to avoid chain movement)
var next_package : Package = null

@onready var animated_sprite_2d = $AnimatedSprite2D

signal lost_package(package_lost : Package)
signal stored_package(package_stored : Package, storage : Storage)

func _ready():
	if not rotate:
		rotation = PI/2
	if down:
		rotation = PI
	animated_sprite_2d.set_frame_and_progress((animated_sprite_2d.frame+1)%4, 0)

func progress():
	if next:
		if not next.next_package and package:
			next.next_package = package
			package = null
	elif package:
		lost_package.emit(package)
		package = null


func update_next():
	if next_package:
		package = next_package
		package.position = position
		next_package = null
		package.tilt()
