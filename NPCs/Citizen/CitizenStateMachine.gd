extends StateMachine

func _ready() -> void:
	#initialize states
	add_state("Idle", $Idle)
	add_state("Protest", $Protest)
	add_state("Join", $Join)


