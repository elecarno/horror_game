extends CharacterBody2D

const max_speed = 80
const accel = 350
const friction = 240

var input = Vector2.ZERO

@onready var flashlight = get_node("flashlight")

func _physics_process(delta):
	player_movement(delta)
	flashlight_update()

func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input.normalized()
	
func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
	move_and_slide()

func flashlight_update():
	flashlight.look_at(get_global_mouse_position())
