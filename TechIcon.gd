extends Control

export (Texture) var icon_texture
export (Texture) var icon_texture_l1
export (Texture) var icon_texture_l2
export (Texture) var icon_texture_l3

func _ready():
	$Icon.texture = icon_texture
	$Icon.set_material($Icon.get_material().duplicate(true))
	#$counter.set("custom_fonts/font", $counter.get("custom_fonts/font").duplicate(true))
	set_amount(randi()%200)
	#gray_out()

func gray_out():
	$Icon.material.set_shader_param("grayout",1.0)
	$progress_particles.hide()
	set_amount(0)

func highlight():
	$Icon.material.set_shader_param("grayout",0.0)
	$progress_particles.hide()	
	
func in_progress():
	$Icon.material.set_shader_param("grayout",0.5)	
	$progress_particles.show()
	
func set_amount(num):
	if num<=1:
		$counter_r.hide()
	else:
		$counter_r.show()
		var txt = "[center]" + String(num) + "[/center]"
		if num<100:
			txt = "[b]"+txt+"[/b]"
		$counter_r.bbcode_text = txt

func set_level(num):
	match num:
		1: $Icon.texture = icon_texture_l1
		2: $Icon.texture = icon_texture_l2
		3: $Icon.texture = icon_texture_l3
		_: $Icon.texture = icon_texture
