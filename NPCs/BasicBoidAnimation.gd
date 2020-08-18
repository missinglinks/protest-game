"""
This scripts flips the sprite and runs the according
animation based on the kinematicbody's velocity
"""

extends AnimationPlayer

onready var host = get_parent()
onready var sprite = host.get_node("Sprite3D")


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	
	if host.velocity.x < 0 and !sprite.flip_h:
		sprite.flip_h = true
	elif host.velocity.x > 0 and sprite.flip_h:
		sprite.flip_h = false
		
	if host.velocity != Vector3.ZERO and current_animation != "Run":
		play("Run")
	elif host.velocity == Vector3.ZERO and current_animation != "Idle":
		play("Idle")