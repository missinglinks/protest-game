extends Spatial

export var beat_manager_node: NodePath
var beat_manager


var tasks = []
var input_cue


# Called when the node enters the scene tree for the first time.
func _ready():
	beat_manager = get_node(beat_manager_node)
	beat_manager.connect("beat_signal", self, "_on_beat_signal")

func add_task(task) -> void:
	tasks.append(task)
	
	
func _on_beat_signal() -> void:
	pass
