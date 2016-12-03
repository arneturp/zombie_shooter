extends KinematicBody2D

onready var player = get_node("../../player")
onready var sample_player = get_node("sample_player")

var health = 100;

const MOVINGSPEED = 250

var velocity = Vector2(0, 0)

func _ready():
	set_fixed_process(true)
	add_to_group("zombies")
	pass

func _fixed_process(delta):
	set_rot( get_pos().angle_to_point( player.get_pos() ));
	velocity.x = sin(get_rot()) * -MOVINGSPEED
	velocity.y = cos(get_rot()) * -MOVINGSPEED
	move(velocity * delta)
	pass

func shot():
	# Decrease health
	health -= floor(rand_range(20, 50))
	print("Remaining health: " + String(health))
	
	# Play SFX
	if (health > 0):
		sample_player.play("zombie_shot_impact_" + String(floor(rand_range(1, 4))))
	else:
		sample_player.play("zombie_final_shot_" + String(floor(rand_range(1, 4))))
		die()
	pass

func die():
	
	pass
