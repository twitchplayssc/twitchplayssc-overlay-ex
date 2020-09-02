extends Control

export (String) var shop_name
export (Color) var panel_color

func _ready():
	$Panel/ShopName.text = shop_name
	$Panel/Shop/shop_option1.set_color(panel_color)
	$Panel/Shop/shop_option2.set_color(panel_color)
	pass
	
func update_state(json):
	if json["show"] == "true":
		show()
	else:
		hide()
	$Panel/Credits.text = json["points"] + " Points"
	$Panel/Shop/shop_option1.update_state(json["1"])
	$Panel/Shop/shop_option2.update_state(json["2"])
