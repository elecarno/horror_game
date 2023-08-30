extends Control

var dragging = false
@onready var item_sprite: TextureRect = get_node("item_sprite")
var item_default_pos: Vector2 = Vector2(10, 250)
var item_selected_pos: Vector2 = Vector2(10, 80)

@export var inv: Node2D
@export var held_item: String = ""

func _on_pouch_button_button_down():
	dragging = true

func _on_pouch_button_button_up():
	dragging = false
	
func _physics_process(delta):
	item_sprite.self_modulate = Color(0.8, 0.8, 0.8)
	if dragging:
		if inv.current_item != held_item:
			var drag_pos = Vector2(item_default_pos.x, get_local_mouse_position().y)
			item_sprite.position = lerp(item_sprite.position, drag_pos, 10 * delta)
			if item_sprite.position.y < item_selected_pos.y:
				inv.inv_switch_item(held_item)
				dragging = false
	else:
		item_sprite.self_modulate = Color(1, 1, 1)
		if inv.current_item == held_item:
			item_sprite.position = item_selected_pos
		else:
			item_sprite.position = lerp(item_sprite.position, item_default_pos, 5 * delta)

