extends Node2D

var segments_path: String = "res://environment/building_segments/"
var segments: Array

var size_counter: int = 0
var max_size: int  = 4

func _ready():
	generate_house()

func generate_house():
	segments = playerdata._collect_resources(segments_path)
	
	randomize()
	var start_segment_index = randi_range(0, segments.size()-1)
	var start_segment: PackedScene = load(segments_path + segments[start_segment_index])
	var start_segment_instance = start_segment.instantiate()
	add_child(start_segment_instance)
	print("started with segment " + start_segment_instance.name)

	#var con_points: Array = get_child(0).connections
	spawn_connections(0)
			
#	for i in range(0, get_children().size()):
#		if i == 0:
#			pass
#		elif size_counter >= max_size:
#			print("max size reached")
#		else:
#			spawn_connections(i)
		
func spawn_connections(core_index):
	for i in range(0, get_child(core_index).get_children().size()):
		var checked_child: String = get_child(core_index).get_child(i).name
		if "left" in checked_child:
			spawn_viable_segment(core_index, "left")
		if "right" in checked_child:
			spawn_viable_segment(core_index, "right")
		if "top" in checked_child:
			spawn_viable_segment(core_index, "top")
		if "down" in checked_child:
			spawn_viable_segment(core_index, "down")

func spawn_viable_segment(core_index, keyword):
	var connectable_segments = get_connectable_segments(keyword)
	var segment_to_spawn_index = randi_range(0, connectable_segments.size()-1)
	
	var segment_to_spawn: PackedScene = load(segments_path + connectable_segments[segment_to_spawn_index])
	var segment_to_spawn_instance = segment_to_spawn.instantiate()
	
	var connection_pos_core: Vector2
	var connection_point_core_index: int
	for i in range(0, get_child(core_index).get_children().size()):
		if keyword in get_child(core_index).get_child(i).name:
			connection_pos_core = get_child(core_index).get_child(i).global_position
			connection_point_core_index = i
	
	var connection_pos_seg: Vector2
	var connection_point_seg_index: int
	for i in range(0, segment_to_spawn_instance.get_children().size()):
		if keyword in segment_to_spawn_instance.get_child(i).name:
			connection_pos_seg = segment_to_spawn_instance.get_child(i).global_position
			connection_point_seg_index = i
	
	segment_to_spawn_instance.position = connection_pos_core
	#segment_to_spawn_instance.position += connection_pos_seg
	
	get_child(core_index).get_child(connection_point_core_index).queue_free()
	segment_to_spawn_instance.get_child(connection_point_seg_index).queue_free()
	
	add_child(segment_to_spawn_instance)
	print("spawned segment " + segment_to_spawn_instance.name + " at position " + keyword)
	
	size_counter += 1

func get_segment_connections(segment):
	var connections: Array
	for i in range(0, segment.get_children().size()):
		connections.append(segment.get_child(i).name)
		
	return connections

func get_connectable_segments(keyword):
	var connectable_segments: Array
	
	for i in range(0, segments.size()):
		var segment_to_check: PackedScene = load(segments_path + segments[i])
		var segment_to_check_instance = segment_to_check.instantiate()
		var connections: Array = get_segment_connections(segment_to_check_instance)
		
		for j in range(0, connections.size()):
			if keyword in connections[j]:
				connectable_segments.append(segments[i])
	
	return connectable_segments
