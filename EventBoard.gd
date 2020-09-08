extends VBoxContainer

const EventLine = preload("res://EventLine.tscn")

func _ready():
	pass

func push_event(text):
	var node = EventLine.instance() 
	node.text = text
	add_child(node)
	if get_child_count() > 7:
		get_child(0).queue_free()
