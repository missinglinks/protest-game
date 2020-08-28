tool
extends Spatial

export var boids_n: int = 1
export var task_size: int = 4
export var no_tasks = 1

var current_task: Node = null
var tasks_completed = 0
var task_boid = null


var min_protest_size = 1

var rude_messages = [
	"we don't care",
	"leave us alone",
	"we don't have time",
	" ... ",
	"go away"
]

var boid_scene = preload("res://NPCs/BasicBoid.tscn")

onready var protest = get_parent().get_parent().get_node("Crowd")




# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Groups")
	randomize()
	
	
	for i in range(boids_n):
		var b = boid_scene.instance()
		$Boids.add_child(b)
		b.global_transform.origin += Vector3(rand_range(-0.3, 0.3), 0, rand_range(-0.3, 0.3))
		#b.set_owner(get_tree().edited_scene_root)

	if boids_n > 3:
		min_protest_size = 5 * (boids_n -1)
	


func remove_interaction() -> void:
	$Area/CollisionShape.disabled = true

func give_task():
	pass

func get_random_boid() -> Boid:
	return $Boids.get_children()[randi()%boids_n]

func add_task():
	task_size = clamp(2 + boids_n * 2, 2, 8) - floor(Refs.crowd.size / 25)	
	
	if !task_boid:
		task_boid = get_random_boid()
	current_task = task_boid.add_task(task_size)
	current_task.connect("task_completed", self, "_on_task_completed")

func show_message():
	var line = rude_messages[randi() % rude_messages.size()]
	get_random_boid().show_message(line)

func add_boids_to_protest():
	for boid in $Boids.get_children():
		boid.add_to_group("Protest")
		boid.join_protest()

func _on_Area_body_entered(body):
	tasks_completed = 0
	if body is Player:
		
		if Refs.crowd.size+1 >= min_protest_size:
			add_task()
		else:
			show_message()

func _on_task_completed() -> void:
	tasks_completed += 1
	if tasks_completed == no_tasks:
		add_boids_to_protest()
		$Area/CollisionShape.disabled = true
	else:
		print("add_task")
		current_task = null
		add_task()

func _on_Area_body_exited(body):
	if task_boid:
		task_boid.remove_task()
		task_boid = null
		current_task = null
