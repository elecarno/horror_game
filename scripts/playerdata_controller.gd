class_name playerdata_controller
extends Node2D

@export var current_item: item_res # reference for the current item that the player is holding

# should probably use an array here
@export var pouch_1: inv_pouch
@export var pouch_2: inv_pouch
@export var pouch_3: inv_pouch

@onready var player: CharacterBody2D = get_parent().get_node("player")

func inv_switch_item(item: item_res):
	current_item = item
	player.switch_item(item)
	print("switched to " + item.item_dislay_name + " (inventory)")
	get_parent().get_node("ui").toggle_inventory()
