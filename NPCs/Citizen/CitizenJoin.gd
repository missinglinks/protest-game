extends State

func enter() -> void:
	host.add_task()


func _on_PlayerNoticeRadius_body_exited(body):
	"""
	remove task if player leaves notice radius and return to 
	idle state
	"""
	if body is Player and !host.joined_protest:
		host.remove_task()
		fsm.transition_to(fsm.states.Idle)
