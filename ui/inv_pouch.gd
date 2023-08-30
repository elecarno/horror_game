class_name inv_pouch
extends Control

@export var inventory: playerdata
@export var held_item: item_res
@export var type_to_hold: String

var dragging = false
@onready var item_sprite: TextureRect = get_node("item_sprite")
var item_default_pos: Vector2 = Vector2(10, 250)
var item_selected_pos: Vector2 = Vector2(10, 80)

func update_pouch():
	if held_item.item_type == "empty":
		item_sprite.visible = false
	else:
		item_sprite.texture = held_item.bag_texture

func _on_pouch_button_button_down():
	dragging = true

func _on_pouch_button_button_up():
	dragging = false
	
func _physics_process(delta):
	item_sprite.self_modulate = Color(0.8, 0.8, 0.8)
	if dragging:
		if inventory.current_item != held_item:
			var drag_pos = Vector2(item_default_pos.x, get_local_mouse_position().y)
			item_sprite.position = lerp(item_sprite.position, drag_pos, 10 * delta)
			if item_sprite.position.y < item_selected_pos.y:
				inventory.inv_switch_item(held_item)
				dragging = false
	else:
		item_sprite.self_modulate = Color(1, 1, 1)
		if inventory.current_item == held_item:
			item_sprite.position = item_selected_pos
		else:
			item_sprite.position = lerp(item_sprite.position, item_default_pos, 5 * delta)

