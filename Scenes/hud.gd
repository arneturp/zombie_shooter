extends CanvasLayer

onready var bullets_label = get_node("bullets/bullets_label")
onready var anim_player = get_node("anim_player")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func animate_reload():
	anim_player.play("animate_reload")
	pass

func update_bullets_label(val):
	bullets_label.set_text(String(val))
	pass
	