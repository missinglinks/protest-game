extends MeshInstance


export var beat_manager_node: NodePath
var beat_manager: BeatManager

onready var collision_shape = $Area/CollisionShape
onready var tween = $Tween

signal player_entered_goal

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	collision_shape.disabled = true
	
	beat_manager = get_node(beat_manager_node)
	beat_manager.connect("beat_input_started", self, "_on_beat_input_started")
	beat_manager.connect("beat_input_ended", self, "_on_beat_input_ended")

func fade_out():
	visible = false

func activate() -> void:
	visible = true
	collision_shape.disabled = false

func _on_beat_input_started() -> void:
	scale = Vector3(1.1, 1.1, 1.1)

func _on_beat_input_ended() -> void:
	scale = Vector3(1.0, 1.0, 1.0)


func _on_Area_body_entered(body):
	if body is Player:
		emit_signal("player_entered_goal")
