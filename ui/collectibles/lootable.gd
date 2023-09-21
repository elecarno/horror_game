extends TextureRect

@onready var collectible: PackedScene = preload("res://ui/collectibles/collectible.tscn")
var current_object: env_lootable

func spawn_contents():
	var content_data = current_object.content_data
	
	for i in range(0, get_children().size()):
		if get_child(i).get_child_count() > 0:
			get_child(i).get_child(0).queue_free()
			
	if content_data != null:
		for i in range(0, content_data.size()):
			if content_data[i] == null:
				continue
			
			var content_spawn = content_data[i]
			get_child(i).add_child(content_spawn)

func update_object_data(object_to_remove):
	var new_content_data: Array = current_object.content_data
	for i in range(0, get_children().size()):
		if get_child(i).get_child_count() > 0:
			if get_child(i).get_child(0) == object_to_remove:
				new_content_data[i] = null
			
	current_object.content_data = new_content_data
	print("updated content data: " + str(new_content_data))
