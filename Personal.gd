extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var zt_scene = preload("res://misc/player_scenes/zergtroll/zergtroll.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func launch(name):
	if name == "zergtroll":
		add_child(zt_scene.instance())
