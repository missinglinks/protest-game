extends State


func _on_PlayerNoticeRadius_body_entered(body):
	if body is Player and not host.joined_protest:
		fsm.transition_to(fsm.states.Join)
		print(body.name)
