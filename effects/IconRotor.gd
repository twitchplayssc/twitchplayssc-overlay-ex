extends Control

export var rotation_speed = 100.0
export var speed = Vector2(0.0,100.0)

func _process(delta):
	$Image.rect_rotation+=rotation_speed*delta
	rect_position += speed*delta

func _ready():
	pass
