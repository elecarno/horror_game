extends CharacterBody2D

@export var DEBUG_DEACTIVATE: bool = false

var speed: int = 50
@export var walk_speed: int = 50
@export var run_speed: int = 100
var vel: Vector2 = Vector2.ZERO

var move_target
var global_delta

@onready var player: CharacterBody2D = get_parent().get_parent().get_node("player")
@onready var close_timer: Timer = get_node("close_timer")
@onready var attack_timer: Timer = get_node("attack_timer")
@onready var reset_timer: Timer = get_node("reset_timer")
@onready var nav_agent: NavigationAgent2D = get_node("nav_agent")

@export var far_stalk_time_range: Vector2 = Vector2(60, 120)
@export var close_stalk_time_range: Vector2 = Vector2(20, 30)
@export var agitated_stalk_time_range: Vector2 = Vector2(30, 60)
@export var attack_persistence_time: int = 20

var randnum: int
var radius: int = 40
var counter: int = 0

var retreats_left: int = 2

enum {
	STALK_FAR,
	STALK_CLOSE,
	ATTACK
}

var state = STALK_FAR

func _ready():
	if DEBUG_DEACTIVATE:
		return

	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")
	
	reset_timer.wait_time = attack_persistence_time
	reset_state()

func reset_state():
	if DEBUG_DEACTIVATE:
		return
		
	attack_timer.stop()
	state = STALK_FAR
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randnum = rng.randf()
	
	get_node("eye_left").enabled = false
	get_node("eye_right").enabled = false
	get_node("sfx_distortion").playing = false
	
	# 20 - 30 seconds
	retreats_left = rng.randi_range(2, 4)
	attack_timer.wait_time = rng.randi_range(close_stalk_time_range.x, close_stalk_time_range.y)
	
	# 1-2 minutes
	close_timer.wait_time = rng.randi_range(far_stalk_time_range.x, far_stalk_time_range.y)
	close_timer.start()
	
	print("enemy stalk timer set to " + str(close_timer.wait_time) + "s")
	print("enemy attack timer set to " + str(attack_timer.wait_time) + "s")
	print("enemy retreats set to " + str(retreats_left))

func actor_setup():
	await get_tree().physics_frame
	
	set_movement_target(get_circle_position(randnum))
	
func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func _physics_process(delta):
	if DEBUG_DEACTIVATE:
		return
	
	global_delta = delta
#	counter += delta
#	radius = lerp(80, 40, abs(sin(counter)))
	match state:
		STALK_FAR:
			radius = 80
			get_node("hitbox/col").disabled = true
			get_parent().get_parent().toggle_attack_shaders(false)
			move_target = get_circle_position(randnum)
		STALK_CLOSE:
			radius = 40
			get_node("hitbox/col").disabled = true
			get_parent().get_parent().toggle_attack_shaders(false)
			move_target = get_circle_position(randnum)
		ATTACK:
			get_node("hitbox/col").disabled = false
			get_parent().get_parent().toggle_attack_shaders(true)
			move_target = player.global_position
			
	move(delta)

func move(delta):
	if nav_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized()
	var desired_vel = new_velocity * speed
	
	var steering = (desired_vel - velocity) * delta * 2.5
	velocity += steering
	
	move_and_slide()

func get_circle_position(random):
	var surround_circle_centre = player.global_position
	var angle = random * PI * 2
	var x = surround_circle_centre.x + cos(angle) * radius
	var y = surround_circle_centre.y + sin(angle) * radius
	
	return Vector2(x, y)

func _on_light_hit():
	if state == STALK_CLOSE and retreats_left > 0:
		speed = run_speed
		attack_timer.stop()
		retreats_left -= 1
		state = STALK_FAR
		close_timer.wait_time = (randi_range(agitated_stalk_time_range.x, agitated_stalk_time_range.y))
		close_timer.start()
		get_node("reset_speed").start()
		get_node("sfx_retreat").playing = true
		print("enemy retreating to far stalking, retreats left: " + str(retreats_left))

func _on_interact():
	if state == ATTACK:
		queue_free()

func _on_close_timer_timeout():
	state = STALK_CLOSE
	attack_timer.start()
	speed = walk_speed
	get_node("eye_left").enabled = false
	get_node("eye_right").enabled = false
	get_node("sfx_close").playing = true
	print("enemy moving to close stalking, " + str(attack_timer.is_stopped()))

func _on_attack_timer_timeout():
	state = ATTACK
	reset_timer.start()
	speed = run_speed
	get_node("eye_left").enabled = true
	get_node("eye_right").enabled = true
	get_node("sfx_attack").playing = true
	get_node("sfx_distortion").playing = true
	print("enemy moving to attack")

func _on_reset_timer_timeout():
	reset_state()
	get_node("sfx_retreat").playing = true
	print("enemy failed to attack player, resetting")
	
func _on_nav_update_timeout():
	if DEBUG_DEACTIVATE:
		return
		
	nav_agent.target_position = move_target

func _on_reset_speed_timeout():
	speed = walk_speed
