"""
This state implements the flocking behaviour
of the crowed
"""

extends State

onready var player: Player = Refs.player
onready var turn_delay_timer: Timer = $TurnDelay

var speed: float = rand_range(0.3, 0.6)
var acceleration: Vector3 = Vector3.ZERO

var perception_radius: float = 0.8
var following_radius: float = 0.3

var steer_force: float = 0.01
var alignment_force: float = rand_range(0.1, 0.2)
var cohesion_force: float = rand_range(0.1, 0.4)
var seperation_force: float = rand_range(0.2, 0.65)
var following_force: float = 0.7

var acceleration_force: float = 50

var target_position: Vector3 = Vector3.ZERO

var can_turn: bool = true



func enter() -> void:
	host.joined_protest = true
	can_turn = true

func update(delta: float) -> State:
	if host.velocity.x < 0 and !host.sprite.flip_h and can_turn:
		can_turn = false
		turn_delay_timer.start()
		host.sprite.flip_h = true
	elif host.velocity.x > 0 and host.sprite.flip_h and can_turn:
		can_turn = false
		turn_delay_timer.start()
		host.sprite.flip_h = false
	return null

func physics_update(delta: float) -> State:
	#update target position
	target_position = player.global_transform.origin
	
	#get neighbouring boids
	var neighbours = get_neighbours()
	
	
	#stop if all neighbours have stopped or are close to stopping
	if neighbours.size() > 0 and player.velocity == Vector3.ZERO:
		var vec = Vector3.ZERO
		for boid in neighbours:
			vec += boid.velocity
		vec /= neighbours.size()
		if vec.length() < 0.3:
			host.velocity = Vector3.ZERO
			
			host.animation_player.update_animation()
			return null
	
	
	#babsic boid behaviour
	acceleration += calculate_alignment(neighbours) * alignment_force
	acceleration += calculate_cohesion(neighbours) * cohesion_force
	acceleration += calculate_seperation(neighbours) * seperation_force * neighbours.size() 
	
	#follow target
	if player.velocity != Vector3.ZERO:
		acceleration += calculate_following(target_position) * following_force
	
	var current_x = host.velocity.x
	
	#var target_vel = host.velocity + acceleration * acceleration_force
	#host.velocity.slerp(target_vel, 0.1)
	
	if host.velocity.length() < speed:
		host.velocity += acceleration * 3 #acceleration_force
	host.velocity.y = 0

		
	host.velocity = host.move_and_slide(host.velocity, Vector3.UP)
	host.velocity *= 0.3
	acceleration *= 0.9
	
	#host.global_transform.origin.y = 8

	host.animation_player.update_animation()
	return null

func calculate_seperation(neighbours: Array) -> Vector3:
	var vec = Vector3.ZERO
	var close_neighbours = []
	
	for boid in neighbours:
		if host.global_transform.origin.distance_to(boid.global_transform.origin) < perception_radius / 2:
			close_neighbours.append(boid)
		
	if close_neighbours.empty():
		return vec
	
	for boid in close_neighbours:
		var diff = host.global_transform.origin - boid.global_transform.origin
		vec += diff.normalized() / diff.length()
		
	vec /= close_neighbours.size()
	
	return steer(vec.normalized() * speed)


func calculate_cohesion(neighbours: Array) -> Vector3:
	var vec = Vector3.ZERO
	
	if neighbours.empty():
		return vec
	
	for boid in neighbours:
		vec += boid.global_transform.origin
	vec /= neighbours.size()
	
	return steer((vec - host.global_transform.origin).normalized() * speed)


func calculate_alignment(neighbours: Array) -> Vector3:
	var vec = Vector3.ZERO
	if neighbours.empty():
		return vec
		
	for boid in neighbours:
		vec += boid.velocity
	
	vec /= neighbours.size()
	
	return steer(vec.normalized() * speed)


func calculate_following(target: Vector3) -> Vector3: 
	
	if host.global_transform.origin.distance_to(target) < following_radius:
		return Vector3.ZERO
	
	return steer((target - host.global_transform.origin).normalized() * speed)


func get_neighbours() -> Array:
	var neighbours = []
	#neighbours.append(Refs.player)
	for boid in get_tree().get_nodes_in_group("Protest"):#host.get_parent().get_children():
		if boid is Boid:
			if host.global_transform.origin.distance_to(boid.global_transform.origin) < perception_radius and not boid == host and boid.fsm.state == boid.fsm.states.Protest:
				neighbours.append(boid)
	return neighbours
	
	
func steer(target: Vector3) -> Vector3:
	var steer: Vector3 = target - host.velocity
	steer = steer.normalized() * steer_force
	
	return steer


func _on_TurnDelay_timeout():
	can_turn = true
