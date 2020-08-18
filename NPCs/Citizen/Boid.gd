"""
Boids are the Kinematicbodies that make up the citizens/the crowd.
States:
	Idle: Just hanging around
	Join: Give the player a 'Task', a condition to join the protest
	Protest: Be part of the protest; behaviour guided by the boid algorithm
	Leave: Leave the protest

The node has also a canvaslayer with for displaying the input task; 
it would be probably better to move them to a central ui layer for tasks
"""


extends KinematicBody
class_name Boid

var velocity: Vector3 = Vector3.ZERO

var task_scene = preload("res://Systems/Task.tscn")
var current_task: Node = null

var joined_protest: bool

onready var sprite = $Sprite3D
onready var fsm = $StateMachine
onready var animation_player = $AnimationPlayer
onready var task_ui = $CanvasLayer/InputChainTask




func _ready() -> void:
	add_to_group("Boids")
	
	#randomize color modulate 
	get_node("Sprite3D").modulate = Color(rand_range(0.5, 1.5), rand_range(0.5,1.5), rand_range(0.5, 1.5), 1)


func setup() -> void:
	pass

func add_task() -> void:
	if current_task == null:
		current_task = task_scene.instance()
		add_child(current_task)
		current_task.setup()
		task_ui.display(current_task)
		current_task.connect("task_completed", self, "_on_task_completed")

func remove_task() -> void:
	task_ui.remove()
	current_task = null

func _on_task_completed() -> void:
	remove_task()
	fsm.transition_to(fsm.states.Protest)
