extends Node2D

var foliage_path: String = "res://environment/foliage/"
var foliage: Array
var structures_path: String = "res://environment/structures/"
var structures: Array

var streetlamp: PackedScene = preload("res://environment/foliage/streetlamp.tscn")
var test_tree: PackedScene = preload("res://environment/foliage/tree_1.tscn")

var tile_data: Dictionary
var object_data: Dictionary

@export var chunk_size = 48 # width and height

var biome_noise = FastNoiseLite.new()
var biome2_noise = FastNoiseLite.new()

@onready var player = get_parent().get_node("player")
@onready var tilemap = get_node("tilemap")
@onready var objects = get_node("objects")

func _ready():
	biome_noise.seed = randi()
	biome2_noise.seed = randi()
	
	foliage = playerdata._collect_resources(foliage_path)

func _on_worldgen_update_timeout():
	pass
	#generate_chunk(player.position)
	#cleanup_objects(player.position)

func _physics_process(delta):
	if Input.is_action_just_pressed("dev_action"):
		generate_chunk(player.position)
		cleanup_objects(player.position)

func generate_chunk(position):
	var tile_pos = tilemap.local_to_map(position)
	
	for x in range(chunk_size):
		for y in range (chunk_size):
			var pos_vector = Vector2i(tile_pos.x-chunk_size/2 + x, tile_pos.y-chunk_size/2 + y)
			var biome = biome_noise.get_noise_2d(pos_vector.x, pos_vector.y)
			var biome2 = biome2_noise.get_noise_2d(pos_vector.x, pos_vector.y)
			
			if object_data.has(str(pos_vector)):
				continue
			
			if tile_data.has(str(pos_vector)):
				continue
			
			if biome * 10 < 0.7:
				tilemap.set_cell(0, pos_vector, 0, Vector2(0,0))
				tile_data[str(pos_vector)] = Vector2(0,0)
			elif biome * 10 < 0.9:
				tilemap.set_cell(0, pos_vector, 0, Vector2(1,0))
				tile_data[str(pos_vector)] = Vector2(1,0)
				
				### spawn street lamps
				if randf_range(0.0, 1.0) < 0.01:
					var streetlamp_instance = streetlamp.instantiate()
					object_data[str(pos_vector)] = streetlamp
			else:
				tilemap.set_cell(0, pos_vector, 0, Vector2(0,0))
				tile_data[str(pos_vector)] = Vector2(0,0)
				
			if biome2 > 0.2:
				tilemap.set_cell(0, pos_vector, 0, Vector2(0,1))
				tile_data[str(pos_vector)] = Vector2(0,1)
				
				### spawn foliage
				if randf_range(0.0, 1.0) < 0.01 and !object_data.has(str(pos_vector)):
					var rand_foliage = foliage[randi() % foliage.size()]
					var foliage_scene: PackedScene = load(foliage_path + rand_foliage)
					object_data[str(pos_vector)] = foliage_scene
					
			if object_data.has(str(pos_vector)):
				var object_instance = object_data[str(pos_vector)].instantiate()
				object_instance.position = tilemap.map_to_local(pos_vector)
				objects.add_child(object_instance)
	#print(object_data)

func cleanup_objects(position):
	for i in range(0, objects.get_children().size()):
		var distance = objects.get_child(i).global_position.distance_to(position)
		if distance > 250:
			objects.get_child(i).queue_free()
