extends TextureRect

@onready var collectible: PackedScene = preload("res://ui/collectibles/collectible.tscn")
var current_object

func generate_contents(content_data: Array):
	for i in range(0, get_children().size()):
		if get_child(i).get_child_count() > 0:
			get_child(i).get_child(0).queue_free()
	
	if content_data != ["null"]:
		for i in range(0, content_data.size()):
			var collectible_instance = collectible.instantiate()
			collectible_instance.contained_collectible = content_data[i]
			get_child(i).add_child(collectible_instance)
		return
	
	randomize()
	var number_of_contents = randi_range(0, get_children().size())
	
	if playerdata.check_for_completion("notes") and playerdata.check_for_completion("journals"):
		print("generated no items due to full completion")
		return
	
	var new_content_data: Array
	for i in range(0, number_of_contents):
		var collectible_instance = collectible.instantiate()
		collectible_instance.contained_collectible = get_random_collectible()
		get_child(i).add_child(collectible_instance)
		new_content_data.append(collectible_instance.contained_collectible)
		print("created collectible containing resource: " + collectible_instance.contained_collectible)
		
	current_object.content_data = new_content_data
	print("generated lootable interior with " + str(number_of_contents) + " items")

func update_object_data():
	var new_content_data: Array
	for i in range(0, get_children().size()):
		var collectible_instance = collectible.instantiate()
		if get_child(i).get_child_count() > 0:
			if !get_child(i).get_child(0).collected:
				new_content_data.append(get_child(i).get_child(0).contained_collectible)
			
	current_object.content_data = new_content_data
	print("updated content data: " + str(new_content_data))

func get_random_collectible():
	randomize()
	var type_number = randi_range(0, 100) # use (0, 2) when adding items
	var type_array: Array
	var collected_type_array: Array
	if type_number <= 75:
		if !playerdata.check_for_completion("journals"):
			type_array = playerdata.journals
			collected_type_array = playerdata.collected_journals
		else:
			type_array = playerdata.notes
			collected_type_array = playerdata.collected_notes
	elif type_number >= 75:
		if !playerdata.check_for_completion("notes"):
			type_array = playerdata.notes
			collected_type_array = playerdata.collected_notes
		else:
			type_array = playerdata.journals
			collected_type_array = playerdata.collected_journals
		
	var cleared_type_array: Array
	for i in range(0, type_array.size()):
		if !collected_type_array.has(i):
			cleared_type_array.append(type_array[i])
	
#	print(type_array)
#	print(cleared_type_array)
	return cleared_type_array[randi() % cleared_type_array.size()]
