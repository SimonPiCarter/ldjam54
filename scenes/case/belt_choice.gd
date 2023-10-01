class_name BeltChoice extends Belt

@export var default_next : Belt = null
@export var alt_next : Belt = null

@onready var texture_button = $TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	if not rotate:
		rotation = PI/2
	next = default_next
	texture_button.pressed.connect(toogle_next)
	animated_sprite_2d.set_frame_and_progress((animated_sprite_2d.frame+1)%4, 0)

func toogle_next():
	if package:
		return
	if next == default_next:
		next = alt_next
		if not rotate:
			rotation = 0
		else:
			rotation = PI/2.
	else:
		next = default_next
		if rotate:
			rotation = 0
		else:
			rotation = PI/2.
