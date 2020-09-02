extends Control

func _ready():
	pass
	
func update_state(json):
	if json["show"] == "true":
		show()
	else:
		hide()
	$Panel/Shop/shop_option1.update_state(json["1"])
	$Panel/Shop/shop_option2.update_state(json["2"])
	$Panel/Shop/shop_option3.update_state(json["3"])
	$Panel/Shop/shop_option4.update_state(json["4"])
	$Panel/Shop/shop_option5.update_state(json["5"])
	$Panel/Shop/shop_option6.update_state(json["6"])
