extends Control

var dragging = false
@onready var item_sprite: TextureRect = get_node("item_sprite")
var item_default_pos: Vector2 = Vector2(10, 250)

func _on_pouch_button_button_down():
	dragging = true

func _on_pouch_button_button_up():
	dragging = false
	
func _physics_process(delta):
	var lerp_counter: float
	if dragging:
		var drag_pos = Vector2(item_default_pos.x, get_local_mouse_position().y)
		#item_sprite.set_position(drag_pos)
		item_sprite.position = lerp(item_sprite.position, drag_pos, 10 * delta)
		if item_sprite.position.y < 80:
			get_parent().switch_item("t1_flashlight")
	else:
		item_sprite.position = lerp(item_sprite.position, item_default_pos, 5 * delta)
		#item_sprite.set_position(item_default_pos)

