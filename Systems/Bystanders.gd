extends Spatial

onready var spawn_areas = $SpawnAreas

var group_scene = preload("res://NPCs/Group.tscn")


var group_sizes = [
	[1, 5],
	[2, 15],
	[3, 10],
	[4, 5],
	[5, 5],
	[6, 5],
	[15, 2]
]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var groups = []
func get_unique_pos() -> Vector3:
	var unique = false
	var pos 
	while !unique:
		unique = true
		pos = spawn_areas.get_random_spawn_position()
		for group in groups:
			if group.distance_to(pos) < 1.4:
				unique = false
				break
	
	groups.append(pos)
	return pos

func setup(n = 150) -> void:
	var spawned = 0
	
	for group in group_sizes:
		for i in range(group[1]):
			var g = group_scene.instance()
			g.boids_n = group[0]
			add_child(g)
			g.global_transform.origin = get_unique_pos()
	


