extends KinematicBody2D

var up_pressed = null
var down_pressed = null
var left_pressed = null
var right_pressed = null
var shoot_pressed = null
var reload_pressed = null

const SHOOTDELAY = 0.2
var shoot_timer = null
var allow_shoot = true

const RELOADDELAY = 3
var reload_timer = null
var allow_reload = true

var velocity = Vector2()
const WALKSPEED = 400

onready var camera = get_node("camera")
onready var anim_player = get_node("anim_player")
onready var gun_anim_player = get_node("gun_anim_player")
onready var sprites = get_node("sprites")
onready var sample_player = get_node("sample_player")
onready var hud = get_node("../hud")

var current_animation = ""
var next_animation = ""

const MAXIMUMBULLETS = 15
var bullets_left = MAXIMUMBULLETS

func _ready():
	# Create timer for shoot delay
	shoot_timer = Timer.new()
	shoot_timer.set_one_shot(true)
	shoot_timer.set_wait_time(SHOOTDELAY)
	shoot_timer.connect("timeout", self, "on_shoot_timout")
	add_child(shoot_timer)

	# Create timer for reload delay
	reload_timer = Timer.new()
	reload_timer.set_one_shot(true)
	reload_timer.set_wait_time(RELOADDELAY)
	reload_timer.connect("timeout", self, "on_reload_timout")
	add_child(reload_timer)

	set_fixed_process(true)
	pass

func _fixed_process(delta):


	# Handle input
	up_pressed = Input.is_action_pressed("player_forward")
	down_pressed = Input.is_action_pressed("player_backward")
	left_pressed = Input.is_action_pressed("player_left")
	right_pressed = Input.is_action_pressed("player_right")
	shoot_pressed = Input.is_action_pressed("player_shoot")
	reload_pressed = Input.is_action_pressed("player_reload")

	# Look at crosshair
	var mouse_pos = camera.get_global_mouse_pos()
	sprites.set_rot(get_pos().angle_to_point(mouse_pos))

	# Control
	velocity.x = 0
	velocity.y = 0
	next_animation = "idle"
	if (up_pressed == true):
		next_animation = "walk"
		velocity.y += -WALKSPEED
	if (down_pressed == true):
		next_animation = "walk"
		velocity.y += WALKSPEED
	if (left_pressed == true):
		next_animation = "walk"
		velocity.x += -WALKSPEED
	if (right_pressed == true):
		next_animation = "walk"
		velocity.x += WALKSPEED
	if ((right_pressed || left_pressed) && (up_pressed || down_pressed)):
		velocity = velocity * Vector2(0.7, 0.7)

	# Control reloading
	if(reload_pressed):
		reload()
	# Control shooting
	if(shoot_pressed && allow_shoot):
		shoot()

	# Move the player
	var motion = velocity * delta
	move(motion)



	if (next_animation != current_animation):
		anim_player.play(next_animation)
		current_animation = next_animation
	pass

func on_shoot_timout():
	allow_shoot = true
	pass

func on_reload_timout():
	allow_reload = true
	allow_shoot = true
	bullets_left = MAXIMUMBULLETS
	hud.update_bullets_label(bullets_left)
	pass

func shoot():
	if (bullets_left > 0):
		# Shake the camera
		camera.shake(0.2, 15, 8)

		# Disable immediate shooting
		allow_shoot = false
		shoot_timer.start()

		# Play animation
		gun_anim_player.play("shoot")

		# Play sound
		sample_player.play("gun_shot")

		# Take bullet away
		bullets_left -= 1
		hud.update_bullets_label(bullets_left)

		# Raycasting
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray( get_global_pos(), camera.get_global_mouse_pos(), [ self ] )
		if (not result.empty()):
			if (result.collider.is_in_group("zombies")):
				result.collider.shot()
	else:
		reload()
	pass

func reload():
	hud.animate_reload()
	allow_shoot = false
	if (allow_reload == false):
		return
	sample_player.play("reload")

	allow_reload = false
	reload_timer.start()
	pass
