extends Control

@export var text = String(""): set = set_text

func set_text(new_value):
	text = new_value
	if has_node("Panel/Label"):
		$Panel/Label.text = new_value

func _ready():
	$Panel/Label.bbcode_enabled = true
	$Panel/Label.text = text

func _on_LifeTime_timeout():
	queue_free()
