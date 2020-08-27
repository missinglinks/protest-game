extends TextureRect


var slot = 0

var textures = {
	InputManager.UP: preload("res://Sprites/UI/up_button.png"),
	InputManager.DOWN: preload("res://Sprites/UI/down_button.png"),
	InputManager.LEFT: preload("res://Sprites/UI/left_button.png"),
	InputManager.RIGHT: preload("res://Sprites/UI/right_button.png"),
	InputManager.BLANK: preload("res://Sprites/UI/input_button.png")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(input_type: int) -> void:
	texture = textures[input_type]

func emit_particles() -> void:
	$CPUParticles2D.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
