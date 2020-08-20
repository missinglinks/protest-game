extends Spatial


func _ready() -> void:

	randomize()

	#$BeatManager.start()
	
	for boid in get_tree().get_nodes_in_group("Boids"):
		boid.setup()
