extends Panel

var style = StyleBoxFlat.new()

func _ready():
	add_stylebox_override("panel", style)
	pass # Replace with function body.

func set_color(col):
	style.set_bg_color(col)

func update_state(json):
	if json["show"] == "true":
		show()
	else:
		hide()
	$Name.text = json["name"]
	$Command.text = json["command"]
	$votes.value = int(json["votes"])
