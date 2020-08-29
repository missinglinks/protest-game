extends TextureRect


var slot:int = 0
var input_type: int
var pressed: bool = false

var textures_up = {
	InputManager.UP: preload("res://Sprites/UI/up_button_1.png"),
	InputManager.DOWN: preload("res://Sprites/UI/down_button_1.png"),
	InputManager.LEFT: preload("res://Sprites/UI/left_button_1.png"),
	InputManager.RIGHT: preload("res://Sprites/UI/right_button_1.png"),
	InputManager.BLANK: preload("res://Sprites/UI/input_button.png")
}
var textures_down = {
	InputManager.UP: preload("res://Sprites/UI/up_button_2.png"),
	InputManager.DOWN: preload("res://Sprites/UI/down_button_2.png"),
	InputManager.LEFT: preload("res://Sprites/UI/left_button_2.png"),
	InputManager.RIGHT: preload("res://Sprites/UI/right_button_2.png"),
	InputManager.BLANK: preload("res://Sprites/UI/input_button.png")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	set("index", 1)
	$CPUParticles2D.set("index", 0)
	pressed = false
	pass # Replace with function body.

func setup(input_type: int) -> void:
	self.input_type = input_type
	texture = textures_up[input_type]

func emit_particles() -> void:
	$CPUParticles2D.emitting = true

func up() -> void:
	texture = textures_up[input_type]

func down() -> void:
	texture = textures_down[input_type]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
