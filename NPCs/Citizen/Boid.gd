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

onready var rc: RayCast = $RayCast

onready var sprite = $Sprite3D2
onready var fsm = $StateMachine
onready var animation_player = $AnimationPlayer
onready var task_ui = $CanvasLayer/InputChainTask

onready var reaction_timer = $ReactionTimer

var skins = [
	#0: preload("res://Sprites/Characters/character_sign_01.png"),
	preload("res://Sprites/Characters/character_01.png"),
	preload("res://Sprites/Characters/character_02.png"),
	preload("res://Sprites/Characters/character_03.png"),
	preload("res://Sprites/Characters/character_04.png"),
	preload("res://Sprites/Characters/character_05.png"),
	
]

var good = [":)", "<3", "!!!"]
var bad = [":/", "...", ":("]

func _ready() -> void:
	add_to_group("Boids")
	
	#randomize color modulate 
	sprite.texture = skins[randi() % skins.size()]
	sprite.modulate = Color(rand_range(0.8, 1.1), rand_range(0.8,1.1), rand_range(0.8, 1.1), 1)
	sprite.scale.y = rand_range(0.7, 1.0)

	if randf() < 0.5:
		sprite.flip_h = true

func setup() -> void:
	$CanvasLayer/InputChainTask.setup()

func join_protest() -> void:
	fsm.transition_to(fsm.states.Protest)
	reaction_timer.wait_time = rand_range(4, 15)
	reaction_timer.start()

func add_task(difficulty: int = 4, lifetime: float = 0) -> Node:
	if current_task == null:
		current_task = task_scene.instance()
		add_child(current_task)
		current_task.setup(difficulty, lifetime)
		task_ui.display(current_task)
		current_task.connect("task_completed", self, "_on_task_completed")
	return current_task

func remove_task() -> void:
	task_ui.remove()
	yield(get_tree().create_timer(0.5), "timeout")
	if is_instance_valid(current_task):
		current_task.remove()
	current_task = null
	

func show_message(line: String, duration: float = 2) -> void:
	task_ui.show_message(line, duration)

func _on_task_completed() -> void:
	remove_task()
	#fsm.transition_to(fsm.states.Protest)


func _on_ReactionTimer_timeout():
	if fsm.state == fsm.states.Protest and current_task == null:
		var message
		if randf() > (Refs.crowd.spirit / 100):
			message = bad[randi()%bad.size()]
		else:
			message = good[randi()%good.size()]
		
		show_message(message, 1)
	reaction_timer.wait_time = rand_range(15, 25)
	reaction_timer.start()
