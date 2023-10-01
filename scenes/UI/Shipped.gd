class_name ShippedUI extends Control

var qty = 0
var type = 0

@onready var label = $Panel/Label
@onready var storage = $Panel/storage

func _ready():
	storage.sprite_2d.texture = preload("res://textures/storage_full.png")

func is_free() -> bool:
	return qty == 0
	
func save(type_in, qty_in):
	qty = qty_in
	type = type_in
	#label.text = String.num(qty)
	storage.qty = qty_in
	storage.type = type_in
	storage.update()
	storage.tilt()
