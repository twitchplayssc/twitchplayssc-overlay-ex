extends Panel

var target_x = -1300
var velocity = 600.0

func activate(text):
	target_x = 10
	$Container/Tip.text = text
	
func deactivate():
	target_x = -1300

func _ready():
	position.x = -1300
	
func _process(delta):
	if position.x < target_x:
		position.x += delta*velocity
	if position.x > target_x + 1.0:
		position.x -= delta*velocity

