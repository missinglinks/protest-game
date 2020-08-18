"""
Handles the citizen input task ui
"""

extends Control

onready var host = get_parent().get_parent()
onready var container = $HBoxContainer
onready var tween = $Tween

var task_symbol_scene = preload("res://UI/Notifications/InputTaskSymbol.tscn")
var current_task 



func _ready() -> void:
	var screen_pos = get_viewport().get_camera().unproject_position(host.global_transform.origin)
	rect_position = screen_pos.floor() + Vector2(-4, - 55)


func _process(delta: float) -> void:
	var screen_pos = get_viewport().get_camera().unproject_position(host.global_transform.origin)
	rect_position = screen_pos.floor() + Vector2(-4, - 55)


func display(task: Task) -> void:
	"""
	creates the onscreen icons for the input task
	"""
	current_task = task
	current_task.connect("task_completion_progress", self, "_on_completion_progress")
	for t in task.task:
		var symbol = task_symbol_scene.instance()
		container.add_child(symbol)
		symbol.setup(t)
		
		
func remove() -> void:
	"""
	fades out and removes the input task icons
	"""
	for symbol in container.get_children():
		tween.interpolate_property(
			symbol, 
			"modulate",
			symbol.modulate,
			Color(1.0, 1.0, 1.0, 0.0),
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(0.3), "timeout")
	for symbol in container.get_children():
		symbol.queue_free()

		
func _on_completion_progress(n):
	"""
	colors the input task icons based on the progression (corrent player inputs)
	"""
	var i = 0
	for symbol in container.get_children():
		if i < n:
			symbol.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			symbol.modulate = Color(1.0, 1.0, 1.0, 1.0)
		i += 1
