extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var dx = 250.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ZT.rect_position.x += dx*delta
	if $ZT.rect_position.x > -50.0:
		dx = -250
	if $ZT.rect_position.x < -500.0:
		queue_free()
