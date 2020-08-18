extends Node

class_name StateMachine

var state: State
var previous: State
var states = {}

var host: Object


func _ready() -> void:
	host = get_parent()


func _physics_process(delta: float) -> void:
	if state:
		var new_state: State = state.physics_update(delta)
		if new_state:
			transition_to(new_state)


func _process(delta: float) -> void:
	if state:
		var new_state: State = state.update(delta)
		if new_state:
			transition_to(new_state)


func transition_to(new_state: State) -> void:
	if state:
		state.exit()
	previous = state
	state = new_state
	state.enter()


func add_state(state_name: String, state_obj: State) -> void:
	states[state_name] = state_obj

func reset():
	pass
