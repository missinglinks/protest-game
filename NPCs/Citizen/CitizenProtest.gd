"""
This state implements the flocking behaviour
of the crowed
"""

extends State

var speed: float = rand_range(0.5, 0.8)
var acceleration: Vector3 = Vector3.ZERO

var perception_radius: float = 0.7
var following_radius: float = 1

var steer_force: float = 0.5
var alignment_force: float = rand_range(0.1, 0.3)
var cohesion_force: float = 0.2
var seperation_force: float = rand_range(0.3, 0.5)
var avoidance_force: float = 0.5
var following_force: float = rand_range(0.2, 0.4)

var target_position: Vector3 = Vector3.ZERO

onready var player = Refs.player

func enter() -> void:
	host.joined_protest = true


func physics_update(delta: float) -> State:
	#update target position
	target_position = player.global_transform.origin
	
	#stop if boid is to close to target
	if host.global_transform.origin.distance_to(target_position) < 0.1:
		host.velocity = Vector3.ZERO
		return null
	
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
			return null
	
	#babsic boid behaviour
	acceleration = process_alignment(neighbours) * alignment_force
	acceleration += process_cohesion(neighbours) * cohesion_force
	acceleration += process_seperation(neighbours) * seperation_force
	
	#follow target
	acceleration += process_following(target_position) * following_force
	
	#move boid
	if host.velocity.length() < speed:
		host.velocity += acceleration 
	host.velocity.y = 0
	host.velocity = host.move_and_slide(host.velocity, Vector3.UP)
	host.velocity *= 0.8

	return null

func process_seperation(neighbours: Array) -> Vector3:
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


func process_cohesion(neighbours: Array) -> Vector3:
	var vec = Vector3.ZERO
	
	if neighbours.empty():
		return vec
	
	for boid in neighbours:
		vec += boid.global_transform.origin
	vec /= neighbours.size()
	
	return steer((vec - host.global_transform.origin).normalized() * speed)


func process_alignment(neighbours: Array) -> Vector3:
	var vec = Vector3.ZERO
	if neighbours.empty():
		return vec
		
	for boid in neighbours:
		vec += boid.velocity
	
	vec /= neighbours.size()
	
	return steer(vec.normalized() * speed)


func process_following(target: Vector3) -> Vector3: 
	
	if host.global_transform.origin.distance_to(target) < following_radius:
		return Vector3.ZERO
	
	return steer((target - host.global_transform.origin).normalized() * speed)


func get_neighbours() -> Array:
	var neighbours = []
	for boid in host.get_parent().get_children():
		if host.global_transform.origin.distance_to(boid.global_transform.origin) < perception_radius and not boid == host:
			neighbours.append(boid)
	return neighbours
	
	
func steer(target: Vector3) -> Vector3:
	var steer: Vector3 = target - host.velocity
	steer = steer.normalized() * steer_force
	
	return steer
