extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func micro(state):
	if state == "off":
		$Minimap.margin_top = 0
	if state == "on":
		$Minimap.margin_top = 365
