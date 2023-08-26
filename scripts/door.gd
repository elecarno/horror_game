extends StaticBody2D

var closed = true

func _on_interact():
	if closed:
		closed = false
		get_node("sprite").visible = false
		get_node("sprite_open").visible = true
		get_node("sprite_top").modulate = Color(1, 1, 1, 0.2)
		get_node("occluder").visible = false
		get_node("nav_obst").avoidance_enabled = false
		set_collision_layer_value(1, false)
	else:
		closed = true
		get_node("sprite").visible = true
		get_node("sprite_open").visible = false
		get_node("sprite_top").modulate = Color(1, 1, 1, 1)
		get_node("occluder").visible = true
		get_node("nav_obst").avoidance_enabled = true
		set_collision_layer_value(1, true)
