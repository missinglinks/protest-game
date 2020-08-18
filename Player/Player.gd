"""
Basic player movement
"""

extends KinematicBody
class_name Player

onready var sprite: Sprite3D = $Sprite3D
onready var ap: AnimationPlayer = $AnimationPlayer


enum states { RUN, IDLE}
var state = states.IDLE

var move_speed: float = .5
var move_vec := Vector3.ZERO
var velocity := Vector3.ZERO


func _ready() -> void:
	ap.play("Idle")
	Refs.player = self


func update_move_vector() -> void:
	move_vec = Vector3(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"), 
		0, 
		Input.get_action_strength("move_down")-Input.get_action_strength("move_up")).normalized()
		
	#rotate sprite if direction changed
	if move_vec.x < 0 and !sprite.flip_h:
		sprite.flip_h = true
	elif move_vec.x > 0 and sprite.flip_h:
		sprite.flip_h = false

func _physics_process(delta: float) -> void:
	update_move_vector()
	
	if move_vec != Vector3.ZERO:
		velocity = move_vec * move_speed
	velocity = move_and_slide(velocity, Vector3.UP)
	
	velocity *= 0.4
	if velocity.length() < 0.05:
		velocity = Vector3.ZERO
	
func _process(delta: float) -> void:
	if velocity != Vector3.ZERO and state == states.IDLE:
		ap.play("Run")
		state = states.RUN
	elif velocity == Vector3.ZERO and state == states.RUN:
		ap.play("Idle")
		state = states.IDLE
