extends Control

var current_item: String = "t1_flashlight"

@onready var pouch_1: Control = get_node("pouch_1")
@onready var pouch_2: Control = get_node("pouch_2")
@onready var pouch_3: Control = get_node("pouch_3")
@onready var player = get_parent().get_parent().get_parent().get_node("player")

func switch_item(item: String):
	current_item = item
	player.switch_item(item)
	print("switched to " + item + " (inventory)")
	get_parent().get_parent().toggle_inventory()
