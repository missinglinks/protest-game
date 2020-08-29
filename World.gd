extends Spatial

onready var tween = $Tween
onready var crowd = $Crowd
onready var player = $Player
onready var start_menu = $UILayer/StartMenu
onready var crowd_size_ui = $UILayer/CrowdSize
onready var spiritmeter_ui = $UILayer/SpiritMeter
onready var time_left_ui = $UILayer/TimeLeft
onready var beat_indicator_ui = $UILayer/BeatIndicatorUI
onready var ending = $UILayer/Ending

onready var return_message = $UILayer/ReturnMessage
onready var goal_indicator = $GoalIndicator

onready var game_timer = $Timer
onready var bystanders = $Bystanders

func fade_in(obj, duration) -> void:
	tween.interpolate_property(
		obj,
		"modulate",
		obj.modulate,
		Color(obj.modulate.r, obj.modulate.g, obj.modulate.b, 1.0),
		duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT		
	)

func fade_out(obj, duration) -> void:
	tween.interpolate_property(
		obj,
		"modulate",
		obj.modulate,
		Color(obj.modulate.r, obj.modulate.g, obj.modulate.b, 0.0),
		duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT		
	)

func _ready() -> void:

	crowd_size_ui.modulate = Color(1, 1, 1, 0)
	spiritmeter_ui.modulate = Color(1, 1, 1, 0)
	time_left_ui.modulate = Color(1, 1, 1, 0)
	beat_indicator_ui.modulate = Color(1, 1, 1, 0)

	randomize()

	$BeatManager.start()
	
	for boid in get_tree().get_nodes_in_group("Boids"):
		boid.setup()

	crowd_size_ui.setup(crowd)
	spiritmeter_ui.setup(crowd)
	time_left_ui.setup(game_timer)

	bystanders.setup()

	start_menu.connect("game_started", self, "_on_game_started")
	goal_indicator.connect("player_entered_goal", self, "_on_player_entered_goal")


func fade_out_ui() -> void:
	fade_out(crowd_size_ui, 2)
	fade_out(return_message, 2)
	fade_out(spiritmeter_ui, 2)
	fade_out(time_left_ui, 2)
	tween.start()


func _on_game_started():
	
	game_timer.start()
	
	fade_in(crowd_size_ui, 2)
	fade_in(beat_indicator_ui, 2)
	fade_in(spiritmeter_ui, 2)
	fade_in(time_left_ui, 2)
	tween.start()
	
	player.allow_input = true

	start_menu.queue_free()

func _on_Timer_timeout():
	return_message.display()
	beat_indicator_ui.visible = false
	goal_indicator.activate()
	
	crowd.deactivate_tasks()	
	for group in get_tree().get_nodes_in_group("Groups"):
		group.remove_interaction()	
	
func _on_player_entered_goal():
	player.allow_input = false
	player.move_to_pos(goal_indicator.global_transform.origin)

	
	goal_indicator.fade_out()
	
	fade_out_ui()
	yield(get_tree().create_timer(3), "timeout")
	ending.display(crowd.size)
	
	
func _process(delta):
	if Input.is_action_just_pressed("return"):
		get_tree().reload_current_scene()
