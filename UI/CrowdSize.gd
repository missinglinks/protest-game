extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(crowd):
	crowd.connect("protest_size_changed", self, "_on_protest_size_changed")
	
func _on_protest_size_changed(size) -> void:
	$Label2.text = str(size+1)
	
