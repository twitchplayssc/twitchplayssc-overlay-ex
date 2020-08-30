extends Control

func _ready():
	pass 

func set_value(val):
	$ProgressBar.value = val
	show()
