tool
extends Spatial

export var boids_n: int = 1
export var task_size: int = 4
export var no_tasks = 1

#ar tasks = []
var current_task: Node = null
var tasks_completed = 0


var boid_scene = preload("res://NPCs/BasicBoid.tscn")

onready var protest = get_parent().get_parent().get_node("Crowd")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(boids_n):
		var b = boid_scene.instance()
		$Boids.add_child(b)
		b.global_transform.origin += Vector3(rand_range(-0.3, 0.3), 0, rand_range(-0.3, 0.3))
		#b.set_owner(get_tree().edited_scene_root)


func give_task():
	pass

func get_random_boid() -> Boid:
	return $Boids.get_children()[randi()%boids_n]

func add_task():
	current_task = get_random_boid().add_task(task_size)
	current_task.connect("task_completed", self, "_on_task_completed")

func add_boids_to_protest():
	for boid in $Boids.get_children():
		boid.add_to_group("Protest")
		boid.join_protest()

func _on_Area_body_entered(body):
	if body is Player:
		add_task()

func _on_task_completed() -> void:
	tasks_completed += 1
	if tasks_completed == no_tasks:
		add_boids_to_protest()
		$Area/CollisionShape.disabled = true
	else:
		add_task()

func _on_Area_body_exited(body):
	pass # Replace with function body.
