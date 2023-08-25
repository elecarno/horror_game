extends CharacterBody2D

const max_speed = 80
const accel = 350
const friction = 240

var light_rot_speed = 0.1

var input = Vector2.ZERO

@onready var flashlight = get_node("flashlight")
@onready var player_sprite = get_node("sprite")
@onready var anim = get_node("anim")
@onready var interact = get_node("interact")

func _physics_process(delta):
	player_movement(delta)
	player_animation()
	flashlight_update(delta)
	interaction()
#	flip()

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
	
func player_animation():
	if input.x > 0:
		anim.play("walk_right")
	elif input.x < 0:
		anim.play("walk_left")
	elif input.y > 0:
		anim.play("walk_towards")
	elif input.y < 0:
		anim.play("walk_away")
	else:
		flip()

func flip():
	var direction = sign(get_global_mouse_position().x - player_sprite.global_position.x)
	if direction < 0:
		#player_sprite.set_flip_h(true)
		anim.play("idle_left")
	else:
		#player_sprite.set_flip_h(false)
		anim.play("idle_right")

func flashlight_update(delta):
	var direction = (get_global_mouse_position() - global_position)
	var angle_to = flashlight.transform.x.angle_to(direction)
	var angle = direction.angle()
	flashlight.rotation = lerp_angle(flashlight.rotation, angle, light_rot_speed)
	#flashlight.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("use_item"):
		flashlight.get_node("spotlight").visible = !flashlight.get_node("spotlight").visible
	
func interaction():
	interact.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("interact") and interact.is_colliding():
		var collider = interact.get_collider()
		if collider.has_method("_on_interact"):
			collider._on_interact()

	
