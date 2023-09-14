extends TileMap

var foliage: Array
var structures: Array

var test_tree = preload("res://environment/foliage/tree_1.tscn")

@export var chunk_size = 32 # width and height

var biome_noise = FastNoiseLite.new()
var biome2_noise = FastNoiseLite.new()

@onready var player = get_parent().get_node("player")

func _ready():
	biome_noise.seed = randi()
	biome2_noise.seed = randi()

func _process(delta):
	if Input.is_action_just_pressed("dev_action"):
		generate_chunk(player.position)
		
	generate_chunk(player.position)
	
func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(chunk_size):
		for y in range (chunk_size):
			var pos_vector = Vector2i(tile_pos.x-chunk_size/2 + x, tile_pos.y-chunk_size/2 + y)
			var biome = biome_noise.get_noise_2d(pos_vector.x, pos_vector.y)
			var biome2 = biome2_noise.get_noise_2d(pos_vector.x, pos_vector.y)
			
			if biome * 10 < 0.7:
				set_cell(0, pos_vector, 0, Vector2(0,0))
			elif biome * 10 < 0.9:
				set_cell(0, pos_vector, 0, Vector2(1,0))
			else:
				set_cell(0, pos_vector, 0, Vector2(0,0))
				
			if biome2 > 0.2:
				set_cell(0, pos_vector, 0, Vector2(0,1))
#				if randf_range(0.0, 1.0) < 0.01:
#					var test_tree_instance = test_tree.instantiate()
#					test_tree_instance.position = map_to_local(pos_vector)
#					add_child(test_tree_instance)
			
			#set_cell(0, Vector2i(tile_pos.x-chunk_size/2 + x, tile_pos.y-chunk_size/2 + y), 0, Vector2(0, 0))
			
