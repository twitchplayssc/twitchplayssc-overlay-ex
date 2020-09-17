extends Control

export var rotation_speed = 0.0
export var speed = Vector2(0.0,0.0)
export var acceleration = Vector2(0.0,0.0)
export var min_limits = Vector2(-300.0, -300.0)
export var max_limits = Vector2(2200.0,1200.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_rotation += delta * rotation_speed
	speed += delta*acceleration
	rect_position += delta * speed
	if rect_position.x < min_limits.x or rect_position.y < min_limits.y:
		queue_free()
	if rect_position.x > max_limits.x or rect_position.y > max_limits.y:
		queue_free()
