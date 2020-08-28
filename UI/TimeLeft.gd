extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(timer: Timer) -> void:
	self.timer = timer
	
func _process(delta: float) -> void:
	
	if timer:
		var time_left: int = floor(timer.time_left) - 1
		if time_left > 0:
		
			#print(time_left)
			var minutes: int = floor(time_left / 60)
			#var seconds = 0
			var seconds: int = time_left % 60
			$Label2.text = "%02d:%02d" % [minutes, seconds]
		
