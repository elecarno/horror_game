class_name ui
extends CanvasLayer

@onready var world_con: world_controller = get_parent()

var using_watch: bool = false

func _process(delta):
	#get_node("control/time_label").text = world_con.format_time()
		
	if Input.is_action_just_pressed("watch"):
		using_watch = true
		get_node("control/watch/watch_open").playing = true
	if Input.is_action_just_released("watch"):
		using_watch = false
		get_node("control/watch/watch_close").playing = true
		
	if using_watch:
		get_node("control/watch").visible = true
		watch_update(delta)
	else:
		get_node("control/watch").visible = false

func watch_update(delta):
	var minutes = int(world_con.tick) % 60
	var hours = int(world_con.tick/60) % 24
	
	get_node("control/watch/minute_hand").rotation_degrees = (360/60) * minutes
	get_node("control/watch/hour_hand").rotation = (((2 * PI) / 12) * hours) + (((2 * PI) / 720) * minutes)

func _on_minute_tick_timer_timeout():
	if using_watch:
		get_node("control/watch/minute_tick").playing = true
