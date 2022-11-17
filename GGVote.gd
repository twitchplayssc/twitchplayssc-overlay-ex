extends Control

var current_value = 0.0
var target_value = 0.0

func _ready():
	pass 

func set_value(val):
	target_value = val/0.6
	show()

func _process(delta):
	if current_value < target_value:
		current_value += 10.0*delta
	if current_value > target_value:
		current_value = target_value
	$ProgressBar.value = current_value
