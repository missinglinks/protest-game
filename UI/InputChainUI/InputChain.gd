"""
Input chain ui
creates ui icons based on player input
"""

extends Node2D

export var input_manager_node: NodePath 
var input_manager: Spatial

var input_symbol_scene = preload("res://UI/InputChainUI/InputButtonSymbol.tscn")


func _ready() -> void:
	input_manager = get_node(input_manager_node)
	input_manager.connect("input_received", self, "_on_input_received")
	input_manager.connect("input_failed", self, "_on_input_failed")

func _on_input_received(input_type: int) -> void:
	
	for child in get_children():
		child.move_down()
	
	var symbol = input_symbol_scene.instance()
	add_child(symbol)
	symbol.setup(input_type)
	
	
func _on_input_failed() -> void:
	modulate = Color(1.0, 0.0, 0.0, 1.0)	
	for child in get_children():
		child.remove()
		
	yield(get_tree().create_timer(0.5), "timeout")
	modulate = Color(1.0, 1.0, 1.0, 1.0)
