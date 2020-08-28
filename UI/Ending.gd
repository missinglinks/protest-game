extends Control

var text_1 = "There was a protest in town"
var text_2 = [
	"only a few people showed up",
	"many people where there",
	"almost everybody was there"
]
var text_3 = [
	"but we won't give up!",
	"and together we continue fighting!",
	"and together we will change the world!"
]

onready var tween = $Tween
onready var label = $Label
onready var buttons = $Buttons

var ending_label_scene = preload("res://UI/EndingLabel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	label.modulate = Color(1, 1, 1, 0)
	buttons.modulate = Color(1, 1, 1, 0)


func show_line(line):
	var l = ending_label_scene.instance()
	add_child(l)
	l.display(line)

func show_buttons():
	$Buttons/MenuButton.grab_focus()
	tween.interpolate_property(
		buttons, 
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	

func display(size = 0) -> void:
	visible = true
	
	var message = 0
	if size < 50:
		message = 0
	elif size < 100:
		message = 1
	else:
		message = 2
	
	yield(get_tree().create_timer(1), "timeout")
	show_line(text_1)

	yield(get_tree().create_timer(7), "timeout")
	show_line(text_2[message])
	
	yield(get_tree().create_timer(7), "timeout")
	show_line(text_3[message])	

	yield(get_tree().create_timer(5), "timeout")
	show_buttons()


func _on_MenuButton_pressed():
	get_tree().reload_current_scene()


func _on_ExitButton_pressed():
	get_tree().quit()
