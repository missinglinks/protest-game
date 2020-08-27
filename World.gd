extends Spatial

onready var crowd = $Crowd
onready var crowd_size_ui = $UILayer/CrowdSize
onready var spiritmeter_ui = $UILayer/SpiritMeter
onready var time_left_ui = $UILayer/TimeLeft
onready var game_timer = $Timer

func _ready() -> void:

	randomize()

	$BeatManager.start()
	
	for boid in get_tree().get_nodes_in_group("Boids"):
		boid.setup()

	crowd_size_ui.setup(crowd)
	spiritmeter_ui.setup(crowd)
	time_left_ui.setup(game_timer)

	game_timer.start()


func _on_Timer_timeout():

	pass
	
	
