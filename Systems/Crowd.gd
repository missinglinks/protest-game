extends Spatial

enum { GAME, END }
var state: int
var size = 0
signal protest_size_changed

var spirit: float = 50
var spirit_step = 5

onready var task_timer: Timer = $TaskTimer

var current_task: Task = null

signal spirit_changed

var good = [ "<3", "!!!", ":)"]
var bad = [ ":/", "...", ":(" ]


func _ready():
	state = GAME
	Refs.crowd = self

func _process(delta: float) -> void:
	var new_size = get_tree().get_nodes_in_group("Protest").size()
	if new_size != size:
		size = new_size
		emit_signal("protest_size_changed", size)

func get_random_protester() -> Boid:
	var protesters = get_tree().get_nodes_in_group("Protest")
	return protesters[randi() % protesters.size()]
	
func deactivate_tasks() -> void:
	task_timer.stop()
	state = END

func _on_TaskTimer_timeout():
	var task_size = 5
	if size  < 100: 
		task_size = 4
	elif size < 75:
		task_size = 3
	elif size < 50:
		task_size = 2
	elif size < 25:
		task_size = 1
	
	if size > 0 and state == GAME:
		var s = clamp(2 + randi() % task_size, 2, 4)
		current_task = get_random_protester().add_task(s, 3 + s)
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



