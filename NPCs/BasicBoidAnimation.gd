"""
This scripts flips the sprite and runs the according
animation based on the kinematicbody's velocity
"""

extends AnimationPlayer

onready var host = get_parent()
onready var sprite = host.get_node("Sprite3D")


func _ready() -> void:
	play("Idle")
	
func update_animation():
	
	if host.fsm.state == host.fsm.states.Protest:
		if host.velocity.length() >= 0.05 and current_animation != "Run":
			play("Run")
		elif host.velocity.length() < 0.05 and current_animation != "ProtestIdle":
			play("ProtestIdle")
