extends Label

onready var tween = $Tween

func display(line) -> void:
	text = line
	tween.interpolate_property(
		self, 
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	
	yield(get_tree().create_timer(3), "timeout")
	
	tween.interpolate_property(
		self, 
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
