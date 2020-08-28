extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.visible = false
	$Label.text = text
	text = ""

func _on_Button_focus_entered():
	$TextureRect.visible = true
	add_color_override("font_color", Color(1, 0, 0 ,1))


func _on_Button_focus_exited():
	$TextureRect.visible = false
	add_color_override("font_color", Color(1, 1, 1, 1))
