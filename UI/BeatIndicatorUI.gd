"""
pulsating icon based on the songs beat
"""

extends Control


export var beat_manager_node: NodePath
var beat_manager: BeatManager


func _ready() -> void:
	beat_manager = get_node(beat_manager_node)
	
	beat_manager.connect("beat_input_started", self, "_on_beat_input_started")
	beat_manager.connect("beat_input_ended", self, "_on_beat_input_ended")
	
func _on_beat_input_started() -> void:
	$TextureRect.rect_scale = Vector2(2, 2)

func _on_beat_input_ended() -> void:
	$TextureRect.rect_scale = Vector2(1, 1)

