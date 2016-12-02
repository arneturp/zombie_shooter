extends Node2D

onready var zombie_scn = preload("res://Scenes/zombie.tscn")

func _ready():
	spawn_zombie(2600, 1600)
	pass

func spawn_zombie(bound_x, bound_y):
	var new_zombie = zombie_scn.instance()
	new_zombie.set_pos(Vector2(rand_range(0, bound_x), rand_range(0, bound_y)))
	add_child(new_zombie)
	pass
