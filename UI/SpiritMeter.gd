extends Control

var current_spirit: float = 50

onready var bar = $TextureProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(crowd) -> void:
	crowd.connect("spirit_changed", self, "_on_spirit_changed")

func _process(delta: float) -> void:
	print(delta)
	if current_spirit < bar.value:
		bar.value = clamp(bar.value - delta * 50, current_spirit, 100.0)
	elif current_spirit > bar.value:
		#bar.value = current_spirit
		bar.value = clamp(bar.value + delta * 50, 0.0, current_spirit)
	print(current_spirit)
	print(bar.value)


func _on_spirit_changed(spirit: float) -> void:
	print("on spirit changed")
	current_spirit = spirit
