class_name world_controller
extends Node2D

const DAY_COLOUR = Color("#abc4c4")
const NIGHT_COLOUR = Color("#040707")
const DAY_COLOUR_UI = Color("#ffffff")
const NIGHT_COLOUR_UI = Color("#4d4d4d")
var TIME_SCALE = 2 # 2 seconds per in-game minute, resulting in a 12 minute day
@onready var canvas_modulate = get_node("modulate")
@onready var ui_modulate = get_node("ui/modulate")

var tick = 0
var time = 0
var daynight_tick = 0

# updating references for time values
var minute_ref: int
var hour_ref: int
var day_ref: int

func _ready():
	## disables development background
	get_node("bg").visible = false
	
	# turns on day/night modulates, 
	# they are turned off in the editor for visbility during development
	canvas_modulate.visible = true
	ui_modulate.visible = true

func _process(delta: float) -> void:
	# updates global references for time values
	minute_ref = int(tick) % 60
	hour_ref = int(tick/60) % 24
	day_ref = int(tick/60/24)
	
	time += delta * TIME_SCALE
	tick = floor(time) + 1440 # 1 day = 1440 minutes
	
	# night to day = 08:00 to 11:00
	# day to night = 17:00 to 21:00
	var current_hour = int(tick/60) % 24
	if current_hour > 7 and current_hour < 12:
		if daynight_tick < 1.0:
			daynight_tick += (delta * TIME_SCALE)/180
			canvas_modulate.color = NIGHT_COLOUR.lerp(DAY_COLOUR, daynight_tick)
			ui_modulate.color = NIGHT_COLOUR_UI.lerp(DAY_COLOUR_UI, daynight_tick)
	elif current_hour > 16 and current_hour < 22:
		if daynight_tick < 1.0:
			daynight_tick += (delta * TIME_SCALE)/240
			canvas_modulate.color = NIGHT_COLOUR.lerp(DAY_COLOUR, 1.0 - daynight_tick)
			ui_modulate.color = NIGHT_COLOUR_UI.lerp(DAY_COLOUR_UI, 1.0 - daynight_tick)
	else:
		daynight_tick = 0
		
	# dev tools - time warp
	if Input.is_action_just_pressed("dev_toggle"):
		if TIME_SCALE == 2:
			TIME_SCALE = 500
		else:
			TIME_SCALE = 2
	
func format_time():
	#return "Day %01d, %02d:%02d\ngametick: %02d\ngametime:%5.1f\ndaynight:%5.5f" % [days, hours, minutes, tick, time, daynight_tick]
	return "Day %01d, %02d:%02d" % [day_ref, hour_ref, minute_ref]

func toggle_attack_shaders(on: bool): 
	# bool is required as this function is sometimes called each frame
	if on:
		get_node("ui/shader").visible = true
		get_node("player/cam").zoom = Vector2(7, 7)
	else:
		get_node("ui/shader").visible = false
		get_node("player/cam").zoom = Vector2(5, 5)

