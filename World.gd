extends Spatial

onready var crowd = $Crowd
onready var crowd_size_ui = $UILayer/CrowdSize
onready var spiritmeter_ui = $UILayer/SpiritMeter

func _ready() -> void:

	randomize()

	$BeatManager.start()
	
	for boid in get_tree().get_nodes_in_group("Boids"):
		boid.setup()

	crowd_size_ui.setup(crowd)
	spiritmeter_ui.setup(crowd)
