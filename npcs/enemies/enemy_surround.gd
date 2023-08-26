extends CharacterBody2D

const speed = 30
var vel = Vector2.ZERO

@onready var player = get_parent().get_parent().get_node("player")

var randnum
var radius = 40
var counter = 0

enum {
	SURROUND,
	ATTACK,
	HIT
}

var state = SURROUND

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randnum = rng.randf()

func _physics_process(delta):
#	counter += delta
#	radius = lerp(80, 40, abs(sin(counter)))
	match state:
		SURROUND:
			move(get_circle_position(randnum), delta)
		ATTACK:
			move(player.global_position, delta)
		HIT:
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

