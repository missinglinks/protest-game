"""
Handles the citizen input task ui
"""

extends Control

onready var host = get_parent().get_parent()
onready var container = $ColorRect/HBoxContainer
onready var tween = $Tween

var task_symbol_scene = preload("res://UI/Notifications/InputTaskSymbol.tscn")
var current_task 
	
var max_completion = -1

func setup() -> void:
	Refs.beat_manager.connect("beat_input_started", self, "_on_beat_input_started")
	Refs.beat_manager.connect("beat_input_ended", self, "_on_beat_input_ended")
	

func _draw():
	draw_line(
		Vector2.ZERO + Vector2(20, 75), 
		Vector2.ZERO + Vector2(8, 95),
		Color(1.0, 1.0, 1.0, 1.0)
		)

func _ready() -> void:
	visible = false
	var screen_pos = get_viewport().get_camera().unproject_position(host.global_transform.origin)
	rect_position = screen_pos.floor() + Vector2(-4, - 140)


func _process(delta: float) -> void:
	var screen_pos = get_viewport().get_camera().unproject_position(host.global_transform.origin)
	rect_position = screen_pos.floor() + Vector2(-4, - 140)
	update()

func display(task: Task) -> void:
	"""
	creates the onscreen icons for the input task
	"""
	
	max_completion = -1
	
	visible = true
	rect_min_size = Vector2(task.task.size() * 45 , 75)
	rect_size = rect_min_size
	
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
	visible = false
		
func _on_completion_progress(n):
	"""
	colors the input task icons based on the progression (corrent player inputs)
	"""
	
	if n < max_completion:
		max_completion = -1
	
	var i = 0
	for symbol in container.get_children():
		if i < n:
			symbol.pressed = true
			symbol.down()
			symbol.modulate = Color(0.6, 0.9, 0.7, 1.0)
			if max_completion < i:
				symbol.emit_particles()
				max_completion = i
		else:
			symbol.pressed = false
			symbol.modulate = Color(1.0, 1.0, 1.0, 1.0)
		i += 1
	
	

func _on_beat_input_started() -> void:
	#$ColorRect/HBoxContainer.modulate = Color(1.0, 1.0, 1.0, 1.0)
	#$ColorRect/HBoxContainer.rect_scale = Vector2(1.05, 1.05)
	for prompt in $ColorRect/HBoxContainer.get_children():
		if !prompt.pressed:
			prompt.down()
	
func _on_beat_input_ended() -> void:
	#$ColorRect/HBoxContainer.modulate = Color(1.0, 1.0, 1.0, 0.7)
	#$ColorRect/HBoxContainer.rect_scale = Vector2(1.0, 1.0)
	for prompt in $ColorRect/HBoxContainer.get_children():
		if !prompt.pressed:
			prompt.up()
