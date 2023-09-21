class_name env_lootable
extends StaticBody2D

@onready var control: Control = get_node("/root/mechanics_dev/ui/control")

@export var type: String = "drawer"

var pos_vector: Vector2i

var content_data: Array = [null]
var generated: bool = false
var number_of_items: int = 1

# item scenes
var collectible: PackedScene = preload("res://ui/collectibles/collectible.tscn")
var glowstick: PackedScene = preload("res://ui/items/glowstick.tscn")

func _on_interact():
	control.get_node("lootables").visible = true
	
	if !generated:
		number_of_items = control.get_node("lootables").get_node(type).get_children().size()
		generate_content_data()
		generated = true
	
	for i in range(0, control.get_node("lootables").get_children().size()):
		control.get_node("lootables").get_child(i).visible = false
	
	control.get_node("lootables").get_node(type).visible = true
	control.get_node("lootables").get_node(type).current_object = self
	control.get_node("lootables").get_node(type).spawn_contents()
	
	print("opened with " + str(content_data))
	
func generate_content_data():
	content_data = []
	
	randomize()
	for i in range(0, number_of_items):
		var rand = randf_range(0, 1)
		if rand <= 0.5:
			if playerdata.check_for_completion("notes") and playerdata.check_for_completion("journals"):
				print("generated no collectibles due to full completion")
			else:
				var new_collectible = collectible.instantiate()
				new_collectible.contained_collectible = playerdata.get_random_collectible()
				content_data.append(new_collectible)
		elif rand > 0.5 and rand <= 0.6:
			var new_glowstick = glowstick.instantiate()
			content_data.append(new_glowstick)
		else:
			content_data.append(null)

