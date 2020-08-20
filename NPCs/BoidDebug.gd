extends Node2D


onready var host = get_parent().get_parent()

var target = Vector2.ZERO 

func _draw():
	draw_line(
		Vector2.ZERO, 
		target,
		Color(1.0, 0.0, 0.0, 1.0)
		)

func _ready():
	pass # Replace with function body.

func _process(delta: float) -> void:
	global_position = get_viewport().get_camera().unproject_position(host.global_transform.origin)
	#print(position)
	
	target = get_viewport().get_camera().unproject_position(host.global_transform.origin + host.velocity)-global_position
	#print(global_position," ", target)
	update()
