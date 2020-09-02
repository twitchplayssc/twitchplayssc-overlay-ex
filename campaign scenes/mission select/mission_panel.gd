extends Panel

func _ready():
	pass # Replace with function body.

func update_state(json):
	if json["show"] == "true":
		show()
	else:
		hide()
	$Name.text = json["name"]
	$votes/Command.text = json["command"]
	$votes.value = int(json["votes"])
