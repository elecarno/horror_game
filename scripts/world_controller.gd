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

func _ready():
	canvas_modulate.visible = true
	ui_modulate.visible = true

func _process(delta: float) -> void:
	time += delta * TIME_SCALE
	tick = floor(time) + 1440 # 1 day = 1440 minutes
	
	# night to day = 08:00 to 11:00
	# day to night = 17:00 to 21:00
	var current_hour = int(tick/60) % 24
	#var reset_daynight = false
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
		
	# dev tools
	if Input.is_action_just_pressed("dev_toggle"):
		if TIME_SCALE == 2:
			TIME_SCALE = 500
		else:
			TIME_SCALE = 2

func triangle(x):
	var fract = x - int(x)
	if fract < 0.5:
		return fract * 2.0
	else:
		return (1.0 - fract) * 2.0
	
func format_time():
	var minutes = int(tick) % 60
	var hours = int(tick/60) % 24
	var days = int(tick/60/24)
	#return "Day %01d, %02d:%02d\ngametick: %02d\ngametime:%5.1f\ndaynight:%5.5f" % [days, hours, minutes, tick, time, daynight_tick]
	return "Day %01d, %02d:%02d" % [days, hours, minutes]

