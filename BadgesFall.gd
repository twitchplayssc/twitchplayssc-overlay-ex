extends Control

const Projectile = preload("res://Projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	for node in $FallingBadges.get_children():
		if node.rect_position.y > 1100:
			node.queue_free()

func launch(badge):
	var node = $BadgesSmall.get_node(badge).duplicate()
	var proj = Projectile.instance()
	proj.rect_position = Vector2(-randf()*100.0+50.0, -randf()*200.0-50.0)
	proj.rotation_speed = randf()*500.0 - 250.0
	proj.acceleration = Vector2(0.0,200.0)
	proj.speed = Vector2(100.0+randf()*300.0, randf()*100.0)
	proj.add_child(node)
	$FallingBadges.add_child(proj)
