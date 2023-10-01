extends Node2D

var multiplier = 1
var score = 0
@onready var label_score = $CanvasLayer/score
@onready var popup_tuto = $popup_tuto
@onready var score_popup_text = $popup_score/score_popup_text
@onready var play = $popup_tuto/Play
@onready var replay = $popup_score/Replay
@onready var texture_button = $CanvasLayer/TextureButton
@onready var popup_score = $popup_score

@onready var belt_chain = $belt_chain

@onready var shipped = [
	$CanvasLayer/HBoxContainer/Shipped,
	$CanvasLayer/HBoxContainer/Shipped2,
	$CanvasLayer/HBoxContainer/Shipped3,
	$CanvasLayer/HBoxContainer/Shipped4,
	$CanvasLayer/HBoxContainer/Shipped5,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up()

	texture_button.pressed.connect(_on_pause)
	play.pressed.connect(_on_play)
	replay.pressed.connect(_on_restart)

	popup_tuto.show()
	stop()

func set_up():
	belt_chain.lost_package.connect(_on_lost_package)
	belt_chain.stored_package.connect(_on_stored_package)
	belt_chain.shipped.connect(_on_shipped)
	

func start():
	belt_chain.paused = false
	texture_button.disabled = false

func stop():
	belt_chain.paused = true
	texture_button.disabled = true

func _on_lost_package(package):
	package.queue_free()

func _on_stored_package(package, _storage):
	$store.play()
	package.queue_free()

func _on_shipped(type, qty):
	$ship.play()

	for shipUI in shipped:
		if shipUI.is_free() and qty > 0:
			shipUI.save(type, qty)

			# update score
			score += multiplier * Constants.scores[qty-1]
			label_score.text = "Score : "+String.num(score)

			break

	var is_over = true
	for shipUI in shipped:
		if shipUI.is_free():
			is_over = false
			break

	if is_over:
		stop()
		popup_score.show()
		if score <= 10:
			score_popup_text.text = "You reached the score of "+String.num(score)+", I am sure you can do better!" \
				+ "\nI hope you enjoyed this jam fest."
		elif score > 10 and score <= 20:
			score_popup_text.text = "You reached the score of "+String.num(score)+" that is good!" \
				+ "\nI hope you enjoyed this jam fest."
		else:
			score_popup_text.text = "You reached the score of "+String.num(score)+" that is excellent!" \
				+ "\nI hope you enjoyed this jam fest."
		print("over")

func _input(event):
	if event.is_action_pressed("escape"):
		popup_tuto.show()
		stop()

	if event.is_action_pressed("pause") and not texture_button.disabled:
		belt_chain.paused = not belt_chain.paused

func _on_pause():
	belt_chain.paused = not belt_chain.paused

func _on_play():
	$clic.play()
	popup_tuto.hide()
	start()

func _on_restart():
	$clic.play()
	popup_score.hide()
	belt_chain.queue_free()
	belt_chain = preload("res://scenes/case/belt_chain.tscn").instantiate()
	add_child(belt_chain)

	popup_tuto.show()
	stop()
