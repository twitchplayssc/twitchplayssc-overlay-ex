extends Panel

const style_tech = preload("res://campaign scenes/armory  shop/StyleTech.tres")
const style_merc = preload("res://campaign scenes/armory  shop/StyleMerc.tres")

func _ready():
	pass # Replace with function body.

func update_state(json):
	if json["show"] == "true":
		show()
	else:
		hide()
	$Name.text = json["name"]
	$Command.text = json["command"]
	$votes.value = int(json["votes"])
	$Price.text = json["price"]	
	$Description/Label.text = json["description"]
	if json["merc"] == "true":
		$bg_merc.show()
		$bg_tech.hide()
	else:
		$bg_merc.hide()
		$bg_tech.show()
