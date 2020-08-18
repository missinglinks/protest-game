"""
A Task is a sequenze of inputs that a player has to perform
"""

extends Node
class_name Task

var task = []
var input_manager: Spatial

var current_progress = 0
var completed = false

signal task_completion_progress
signal task_completed


# Called when the node enters the scene tree for the first time.
func _ready():
	print("test")

	pass
	
func setup(n: int = 4, timed: bool = false) -> void:
	task = generate_random_task(n)
	
	input_manager = Refs.input_manager
	input_manager.connect("input_received", self, "_on_input_received")


func generate_random_task(n: int = 4) -> Array:
	"""
	Generates a random input sequenze of the length :n:
	Cannot beginn with a blank input
	"""
	var task = []
	task.append(randi() % 4)
	for i in range(n-1):
		task.append(randi() % 5)
	return task
	
func _on_input_received(input_type: int) -> void:
	"""
	check every player input if the task is completed or if progress is made
	"""
	if completed:
		return
	
	if input_type == task[current_progress]:
		current_progress += 1
		emit_signal("task_completion_progress", current_progress)
	else:
		current_progress = 0
		emit_signal("task_completion_progress", current_progress)
	
	if current_progress == task.size():
		completed = true
		emit_signal("task_completed")

func remove() -> void:
	queue_free()
