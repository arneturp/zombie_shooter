extends Node2D

onready var zombie_scn = preload("res://Scenes/zombie.tscn")

func _ready():
	spawn_zombie()
	pass

func spawn_zombie():
	var new_zombie = zombie_scn.instance()
	add_child(new_zombie)
	pass