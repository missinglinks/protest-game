extends Spatial

var marker = preload("res://City/Tree.tscn")

func get_random_spawn_position() -> Vector3:
	
	var areas = get_children()
	var area: Area = areas[randi() % areas.size()]
	var shape: CollisionShape = area.get_node("CollisionShape")
	var x_offset = abs(shape.shape.extents.x) / 2
	var z_offset = abs(shape.shape.extents.z) / 2
	var x_start = shape.global_transform.origin.x - x_offset 
	var z_start = shape.global_transform.origin.z - z_offset
	
	var pos = Vector3(
		rand_range(x_start, x_start +  x_offset * 2),
		0,
		rand_range(z_start, z_start + z_offset * 2)
	)
	
	return pos


# Called when the node enters the scene tree for the first time.
func _ready():
	"""
	for area in get_children():
		print(area.name)
		var shape: CollisionShape = area.get_node("CollisionShape")
		var m = marker.instance()
		shape.add_child(m)
		m.scale = Vector3(0.1, 0.1, 0.1)
		#m.global_transform.origin = area.global_transform.origin
		#m.global_transform.origin.y = 0
	"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
