extends Control

export var value = String("")
export var label = String("")

func _ready():
	$Label.text = label
	$Value.text = value

