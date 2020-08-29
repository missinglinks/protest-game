extends Control
 
onready var bg = $StartMenuBG
onready var tween = $Tween

onready var credits = $Credits
onready var title = $Title
onready var subtitle = $Subtitle
onready var buttons = $Buttons

signal game_started

func fade_in(obj, duration) -> void:
	tween.interpolate_property(
		obj,
		"modulate",
		obj.modulate,
		Color(obj.modulate.r, obj.modulate.g, obj.modulate.b, 1.0),
		duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT		
	)
	tween.start()


func fade_out(obj, duration) -> void:
	tween.interpolate_property(
		obj,
		"modulate",
		obj.modulate,
		Color(obj.modulate.r, obj.modulate.g, obj.modulate.b, 0.0),
		duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT		
	)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	title.modulate = Color(1, 1, 1, 0)
	subtitle.modulate = Color(1, 1, 1, 0)
	buttons.modulate = Color(1, 1, 1, 0)
	
	fade_in(title, 2)
	yield(get_tree().create_timer(1), "timeout")
	
	#yield(get_tree().create_timer(2), "timeout")
	
	tween.interpolate_property(
		bg,
		"modulate",
		bg.modulate,
		Color(bg.modulate.r, bg.modulate.g, bg.modulate.b, 0.7),
		5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	
	
	yield(get_tree().create_timer(1), "timeout")
	fade_in(subtitle, 2)
	
	
	yield(get_tree().create_timer(1), "timeout")
	fade_in(buttons, 2)
	$Buttons/StartButton.grab_focus()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_StartButton_pressed():
	
	fade_out(buttons, 2)
	fade_out(title, 2)
	fade_out(subtitle, 2)
	fade_out(credits, 2)
	tween.start()
	
	yield(get_tree().create_timer(2), "timeout")
	
	fade_out(bg, 3)
	tween.start()
	yield(get_tree().create_timer(1), "timeout")
	
	emit_signal("game_started")


func _on_ControlsButton_pressed():
	$Controls.visible = !$Controls.visible
