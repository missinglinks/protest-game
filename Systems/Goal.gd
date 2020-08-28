extends Spatial

onready var col = $Area/CollisionShape
onready var timer = $Timer

signal goal_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	col.disabled = true
	visible = false


func activate() -> void:
	visible = true
	col.disabled = false


func _on_Area_body_entered(body):
	if body is Player:
		timer.start()


func _on_Timer_timeout():
	emit_signal("goal_reached")
