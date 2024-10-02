extends Panel

var target_x = -1300
var velocity = 600.0

func activate(text):
	target_x = 10
	$Container/Tip.bbcode_text = text
	
func deactivate():
	target_x = -1300

func _ready():
	rect_position.x = -1300
	
func _process(delta):
	if rect_position.x < target_x:
		rect_position.x += delta*velocity
	if rect_position.x > target_x + 1.0:
		rect_position.x -= delta*velocity

