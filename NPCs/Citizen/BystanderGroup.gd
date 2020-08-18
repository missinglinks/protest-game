extends Spatial

var input_chain = []
var difficulty = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(difficulty):
		match randi() % 5:
			InputManager.UP: input_chain.append(InputManager.UP)
			InputManager.DOWN: input_chain.append(InputManager.DOWN)
			InputManager.LEFT: input_chain.append(InputManager.LEFT)
			InputManager.RIGHT: input_chain.append(InputManager.RIGHT)
			InputManager.BLANK: input_chain.append(InputManager.BLANK)




func _on_Area_body_entered(body):
	pass # Replace with function body.


func _on_Area_body_exited(body):
	pass # Replace with function body.
