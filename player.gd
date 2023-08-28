extends CharacterBody2D

const max_speed = 80
const accel = 350
const friction = 240

var input = Vector2.ZERO


var light_rot_speed = 0.1

var hp = 3

@onready var flashlight = get_node("flashlight")
@onready var player_sprite = get_node("sprite")
@onready var anim = get_node("anim")
@onready var interact = get_node("interact")
@onready var light_hit = get_node("flashlight/light_hit")

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
		
	if anim.current_animation == "walk_away":
		flashlight.z_index = -1
	else:
		flashlight.z_index = 0

func flip():
	var direction = sign(get_global_mouse_position().x - player_sprite.global_position.x)
	if direction < 0:
		#player_sprite.set_flip_h(true)
		anim.play("idle_left")
	else:
		#player_sprite.set_flip_h(false)
		anim.play("idle_right")

func flashlight_update(_delta):
	var direction = (get_global_mouse_position() - global_position)
	var angle = direction.angle()
	flashlight.rotation = lerp_angle(flashlight.rotation, angle, light_rot_speed)
	#flashlight.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("use_item"):
		flashlight.get_node("spotlight").visible = !flashlight.get_node("spotlight").visible
		light_hit.enabled = !light_hit.enabled
	
func interaction():
	interact.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("interact") and interact.is_colliding():
		var collider = interact.get_collider()
		if collider != null and collider.has_method("_on_interact"):
			collider._on_interact()
	
	if light_hit.enabled:
		var collider = light_hit.get_collider()
		if collider != null and collider.has_method("_on_light_hit"):
			collider._on_light_hit()

func take_damage():
	hp -= 1
	print("------------------")
	print("player lost 1 hp")
	
	if hp <= 0:
		print("player died")
