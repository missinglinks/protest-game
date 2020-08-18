extends Node

class_name State

# references to state machine and host object
onready var fsm: Object = get_parent()
onready var host: Object = fsm.get_parent()

func _ready() -> void:
	pass

func enter() -> void:
	pass


func update(delta: float) -> State:
	return null


func physics_update(delta: float) -> State:
	return null


func exit() -> void:
	pass
