extends Control

export var text = String("") setget set_text

func set_text(new_value):
	text = new_value
	if $Panel/Label != null:
		$Panel/Label.bbcode_text = new_value

func _ready():
	$Panel/Label.bbcode_text = text

func _on_LifeTime_timeout():
	queue_free()
