extends Spatial

var size = 0
signal protest_size_changed

var spirit: float = 50
var spirit_step = 5

onready var task_timer: Timer = $TaskTimer

var current_task: Task = null


signal spirit_changed

func _ready():
	pass # Replace with function body.

func _process(delta: float) -> void:
	var new_size = get_tree().get_nodes_in_group("Protest").size()
	if new_size != size:
		size = new_size
		emit_signal("protest_size_changed", size)

func get_random_protester() -> Boid:
	var protesters = get_tree().get_nodes_in_group("Protest")
	return protesters[randi() % protesters.size()]
	


func _on_TaskTimer_timeout():
	if size > 0:
		current_task = get_random_protester().add_task(4, 5)
		current_task.connect("task_completed", self, "_on_task_completed")
		current_task.connect("task_failed", self, "_on_task_failed")
		
	task_timer.wait_time = rand_range(14, 18)
	task_timer.start()
	
	
func _on_task_completed() -> void:
	spirit = clamp(spirit + spirit_step, 0, 100)
	emit_signal("spirit_changed", spirit)
	
	
func _on_task_failed() -> void:
	spirit = clamp(spirit - spirit_step, 0, 100)
	emit_signal("spirit_changed", spirit)
