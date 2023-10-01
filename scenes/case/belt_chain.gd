class_name BeltChain extends Node2D

@export var spawn_rate = 3
@export var tick_rate = 0.5
var elapsed = 0
var elapsed_2 = spawn_rate

signal lost_package(lost_package)
signal stored_package(stored_package, storage)
signal shipped(type, qty)

var paused = false

@export var start_belt : Belt = null

func _ready():
	for child in get_children():
		if child is Belt:
			child.lost_package.connect(_on_lost_package)
			child.stored_package.connect(_on_stored_package)
		elif child is Storage:
			child.ship.connect(_on_ship)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not paused:
		elapsed += delta
		elapsed_2 += delta

	while elapsed > tick_rate:
		elapsed -= tick_rate
		for child in get_children():
			if child is Belt:
				child.progress()
		for child in get_children():
			if child is Belt:
				child.update_next()

	while elapsed_2 > spawn_rate and start_belt and not start_belt.next_package:
		elapsed_2 -= spawn_rate
		var package = preload("res://scenes/package.tscn").instantiate()
		package.position.x = -50
		add_child(package)
		package.type = randi_range(0, Constants.nb_typpes-1)
		package.sprite_2d.texture = Constants.textures[package.type]

		start_belt.next_package = package

func _on_lost_package(package):
	lost_package.emit(package)
	shipped.emit(package.type, 1)

func _on_stored_package(package, storage):
	storage.store_package(package)
	stored_package.emit(package, storage)

func _on_ship(type, qty):
	shipped.emit(type, qty)
