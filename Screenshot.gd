extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

var tmp = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tmp+=delta
	if tmp > 5.0:
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("scene_screenshot.png")
		tmp = -500.0
	pass
