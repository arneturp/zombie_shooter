extends KinematicBody2D

onready var player = get_node("../../player")

const MOVINGSPEED = 150

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
