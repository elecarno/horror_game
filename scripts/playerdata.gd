extends Node2D

var current_item: String = "t1_flashlight"

@export var pouch_1: Control
@export var pouch_2: Control
@export var pouch_3: Control
@onready var player: CharacterBody2D = get_parent().get_node("player")

func inv_switch_item(item: String):
	current_item = item
	player.switch_item(item)
	print("switched to " + item + " (inventory)")
	get_parent().get_node("ui").toggle_inventory()
