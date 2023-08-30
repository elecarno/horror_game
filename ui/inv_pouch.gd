class_name inv_pouch
extends Control

@export var inventory: playerdata
@export var held_item: item_res
@export var type_to_hold: String

var dragging = false
@onready var item_sprite: TextureRect = get_node("item_sprite")
@onready var item_label: RichTextLabel = get_node("item_name")
var item_default_pos: Vector2 = Vector2(10, 250)
var item_selected_pos: Vector2 = Vector2(10, 80)

func update_pouch():
	if held_item.item_type == "empty":
		item_sprite.visible = false
		item_label.text = ""
	else:
		item_sprite.texture = held_item.bag_texture
		item_label.text = "[center]" + held_item.item_dislay_name

func _on_pouch_button_button_down():
	if held_item.item_type != "empty":
		dragging = true
		item_label.visible = true

func _on_pouch_button_button_up():
	dragging = false
	item_label.visible = false
	
func _physics_process(delta):
	item_sprite.self_modulate = Color(0.8, 0.8, 0.8)
	if dragging:
		if inventory.current_item != held_item:
			var drag_pos = Vector2(item_default_pos.x, get_local_mouse_position().y)
			item_sprite.position = lerp(item_sprite.position, drag_pos, 10 * delta)
			item_sprite.position.y = clampf(item_sprite.position.y, item_selected_pos.y, item_default_pos.y)
			if item_sprite.position.y <= item_selected_pos.y:
				inventory.inv_switch_item(held_item)
				dragging = false
				item_label.visible = false
	else:
		item_sprite.self_modulate = Color(1, 1, 1)
		if inventory.current_item == held_item:
			item_sprite.position = item_selected_pos
		else:
			item_sprite.position = lerp(item_sprite.position, item_default_pos, 5 * delta)

