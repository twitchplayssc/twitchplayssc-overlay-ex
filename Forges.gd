extends Control

const ForgeIcon = preload("res://effects/forge_icon.tscn")

func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	for node in get_children():
		if node.rect_position.y > 1100:
			node.queue_free()

func launch():
	for _i in range(200):
		var node = ForgeIcon.instance()
		node.rect_position = Vector2(randf()*1920.0, -(randf()*2000.0+100.0))
		node.rotation_speed = randf()*500.0 - 250.0
		node.speed = Vector2(0.0, randf()*100.0+100.0)
		add_child(node)
	for _i in range(200):
		var node = ForgeIcon.instance()
		node.rect_position = Vector2(randf()*1920.0, -(randf()*2000.0+1000.0))
		node.rotation_speed = randf()*500.0 - 250.0
		node.speed = Vector2(0.0, randf()*100.0+100.0)
		add_child(node)
