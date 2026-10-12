extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = -800
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x < 0.0:
		position.x += 700.0*delta
	else:
		position.x = 0.0
