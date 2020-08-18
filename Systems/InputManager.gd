"""
receives the input signals from the beat manager and
stores them in a list.
upon receiving a mistimed input signal, the list is cleared.
"""

extends Spatial
class_name InputManager

enum { UP, DOWN, LEFT, RIGHT, BLANK }

export var beat_manager_node: NodePath
var beat_manager: BeatManager

var input_chain = []
const MAX_INPUT: int = 9

signal input_received
signal input_failed


func _ready() -> void:
	Refs.input_manager = self
	
	beat_manager = get_node(beat_manager_node)
	beat_manager.connect("mistimed_input", self, "_on_mistimed_input")
	beat_manager.connect("beat_input", self, "_on_beat_input")

func _on_mistimed_input(event: InputEvent) -> void:
	emit_signal("input_failed")
	input_chain = []
	
func _on_beat_input(event: InputEvent) -> void:
	
	var input_type: int = BLANK
	
	if event != null:
		if event.is_action("dance_up"):
			input_type = UP
		elif event.is_action("dance_down"):
			input_type = DOWN
		elif event.is_action("dance_left"):
			input_type = LEFT
		elif event.is_action("dance_right"):
			input_type = RIGHT
			
	input_chain.push_front(input_type)
	if input_chain.size() > MAX_INPUT:
		input_chain.remove(MAX_INPUT)
	
	emit_signal("input_received", input_type)
	
	

