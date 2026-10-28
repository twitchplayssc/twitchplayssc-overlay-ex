extends Control

@export var icon_texture: Texture2D
@export var icon_texture_l1: Texture2D
@export var icon_texture_l2: Texture2D
@export var icon_texture_l3: Texture2D

func _ready():
	$Icon.texture = icon_texture
	$Icon.set_material($Icon.get_material().duplicate(true))
	#$counter.set("custom_fonts/font", $counter.get("custom_fonts/font").duplicate(true))
	set_amount(randi()%200)
	#gray_out()

func gray_out():
	$Icon.material.set_shader_parameter("grayout",1.0)
	$progress_particles.hide()
	set_amount(0)
	hide_star()

func highlight():
	$Icon.material.set_shader_parameter("grayout",0.0)
	$progress_particles.hide()	
	
func show_star():
	$star.show()
	
func hide_star():
	$star.hide()
	
func in_progress():
	$Icon.material.set_shader_parameter("grayout",0.5)	
	$progress_particles.show()
	
func set_amount(num):
	if num<=1:
		$counter_r.hide()
	else:
		$counter_r.show()
		var txt = str(num)
		if num<100:
			txt = "[b]"+txt+"[/b]"
		txt = "[center]" + txt + "[/center]"
		$counter_r.text = txt

func set_level(num):
	match num:
		1: $Icon.texture = icon_texture_l1
		2: $Icon.texture = icon_texture_l2
		3: $Icon.texture = icon_texture_l3
		_: $Icon.texture = icon_texture
