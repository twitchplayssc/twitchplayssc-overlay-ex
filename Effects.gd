extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var b_forges = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	b_forges = false

func launch(effect):
	if effect["type"]=="forges" and not b_forges:
		$Forges.launch()
		b_forges = true
	if effect["type"]=="badge":
		$BadgesFall.launch(effect["param"])
