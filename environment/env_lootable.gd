extends StaticBody2D

@onready var control: Control = get_node("/root/mechanics_dev/ui/control")

@export var type: String = "drawer"

func _on_interact():
	control.get_node("lootables").visible = true
	control.get_node("lootables").get_node(type).visible = true

