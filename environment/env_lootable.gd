extends StaticBody2D

@onready var control: Control = get_node("/root/mechanics_dev/ui/control")

@export var type: String = "drawer"

var pos_vector: Vector2i

var content_data: Array = ["null"]

func _on_interact():
	control.get_node("lootables").visible = true
	
	for i in range(0, control.get_node("lootables").get_children().size()):
		control.get_node("lootables").get_child(i).visible = false
	
	control.get_node("lootables").get_node(type).visible = true
	control.get_node("lootables").get_node(type).current_object = self
	control.get_node("lootables").get_node(type).generate_contents(content_data)
	#content_data = control.get_node("lootables").get_node(type).new_content_data

