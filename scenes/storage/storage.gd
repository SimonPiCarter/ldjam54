class_name Storage extends Node2D

var type = 0
var qty = 0
var max_qty = 5

@onready var package_type = $Sprite2D/package
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

@onready var label = $Label
@onready var texture_button = $TextureButton

signal ship(type, qty)

func _ready():
	label.text = String.num(qty)+"/"+String.num(max_qty)
	
	texture_button.pressed.connect(_on_ship)

	package_type.hide()

func tilt():
	animation_player.play("tilt")

func store_package(package : Package):
	if qty > 0 and type != package.type:
		ship.emit(type, qty)
		qty = 1
		type = package.type
		animation_player.play("tilt_fail")
	else:
		type = package.type
		qty += 1
		tilt()

	if qty == max_qty:
		ship.emit(type, qty)
		qty = 0
		animation_player.play("tilt_success")

	update()

func _on_ship():
	if qty > 0:
		ship.emit(type, qty)
		qty = 0
		update()

func update():
	if qty > 0:
		package_type.texture = Constants.textures[type]
		package_type.show()
	else:
		package_type.hide()
	label.text = String.num(qty)+"/"+String.num(max_qty)
