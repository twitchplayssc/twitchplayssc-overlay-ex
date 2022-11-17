extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var i = 0
var ys = [-5 ,-375, -742]

func _on_RotateTPRace_timeout():
	i = (i+1)%3
	$GCC/GridContainer.rect_position.y = ys[i]
	pass # Replace with function body.
