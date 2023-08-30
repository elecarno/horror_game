class_name ui
extends CanvasLayer

@onready var world_con: world_controller = get_parent()
@onready var playerdata_con: playerdata = get_parent().get_node("playerdata_con")

var using_watch: bool = false

func _process(delta):
	if Input.is_action_just_pressed("notebook"):
		get_node("control/notebook").visible = !get_node("control/notebook").visible
		get_node("control/notebook/day_counter").text = "Day #" + str(world_con.day_ref)
		
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()
		
	if Input.is_action_just_pressed("watch"):
		using_watch = true
		get_node("control/watch/watch_open").playing = true
	if Input.is_action_just_released("watch"):
		using_watch = false
		get_node("control/watch/watch_close").playing = true
		
	if using_watch:
		get_node("control/watch").visible = true
		watch_update()
	else:
		get_node("control/watch").visible = false

func watch_update():
	get_node("control/watch/minute_hand").rotation_degrees = (360/60) * world_con.minute_ref
	get_node("control/watch/hour_hand").rotation = (((2 * PI) / 12) * world_con.hour_ref) + (((2 * PI) / 720) * world_con.minute_ref)

func toggle_inventory():
	get_node("control/inventory").visible = !get_node("control/inventory").visible
	playerdata_con.pouch_1.update_pouch()
	playerdata_con.pouch_2.update_pouch()
	playerdata_con.pouch_3.update_pouch()

func _on_minute_tick_timer_timeout():
	if using_watch:
		get_node("control/watch/minute_tick").playing = true
