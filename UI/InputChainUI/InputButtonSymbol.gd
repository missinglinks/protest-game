extends Sprite

onready var tween = $Tween

var slot = 0

var textures = {
	InputManager.UP: preload("res://Sprites/UI/up_button.png"),
	InputManager.DOWN: preload("res://Sprites/UI/down_button.png"),
	InputManager.LEFT: preload("res://Sprites/UI/left_button.png"),
	InputManager.RIGHT: preload("res://Sprites/UI/right_button.png"),
	InputManager.BLANK: preload("res://Sprites/UI/input_button.png")
}


func setup(input_type: int) -> void:
	texture = textures[input_type]

func move_down() -> void:

	tween.interpolate_property(
		self, 
		"position", 
		position, 
		position + Vector2(0, 70), 
		0.1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	slot += 1
	if slot > 7:
		remove()
	
func remove() -> void:
	#tween.stop()
	tween.interpolate_property(
		self, 
		"modulate", 
		Color(1.0, 1.0, 1.0, 1.0), 
		Color(1.0, 1.0, 1.0, 0.0), 
		0.4, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT)	
	tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
