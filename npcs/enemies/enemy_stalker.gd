extends CharacterBody2D

const speed = 30
var vel = Vector2.ZERO

@onready var player = get_parent().get_parent().get_node("player")
@onready var close_timer = get_node("close_timer")
@onready var attack_timer = get_node("attack_timer")
@onready var reset_timer = get_node("reset_timer")

var randnum
var radius = 40
var counter = 0

var retreats_left = 2

enum {
	STALK_FAR,
	STALK_CLOSE,
	ATTACK
}

var state = STALK_FAR

func _ready():
	reset_state()

func reset_state():
	attack_timer.stop()
	state = STALK_FAR
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randnum = rng.randf()
	
	# 20 - 30 seconds
	retreats_left = rng.randi_range(2, 4)
	attack_timer.wait_time = rng.randi_range(20, 30)
	
	# 1-2 minutes
	close_timer.wait_time = rng.randi_range(60, 120)
	close_timer.start()
	
	print("enemy stalk timer set to " + str(close_timer.wait_time) + "s")
	print("enemy attack timer set to " + str(attack_timer.wait_time) + "s")
	print("enemy retreats set set to " + str(retreats_left))

func _physics_process(delta):
#	counter += delta
#	radius = lerp(80, 40, abs(sin(counter)))
	match state:
		STALK_FAR:
			radius = 80
			get_node("hitbox/col").disabled = true
			move(get_circle_position(randnum), delta)
		STALK_CLOSE:
			radius = 40
			get_node("hitbox/col").disabled = true
			move(get_circle_position(randnum), delta)
		ATTACK:
			get_node("hitbox/col").disabled = false
			move(player.global_position, delta)

func move(target, delta):
	var direction = (target - global_position).normalized()
	var desired_vel = direction * speed
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
		attack_timer.stop()
		retreats_left -= 1
		state = STALK_FAR
		close_timer.wait_time = (randi_range(30, 60))
		close_timer.start()
		print("enemy retreating to far stalking, retreats left: " + str(retreats_left))

func _on_interact():
	if state == ATTACK:
		queue_free()

func _on_close_timer_timeout():
	state = STALK_CLOSE
	attack_timer.start()
	print("enemy moving to close stalking, " + str(attack_timer.is_stopped()))

func _on_attack_timer_timeout():
	state = ATTACK
	reset_timer.start()
	print("enemy moving to attack")

func _on_reset_timer_timeout():
	reset_state()
	print("enemy failed to attack player, resetting")
