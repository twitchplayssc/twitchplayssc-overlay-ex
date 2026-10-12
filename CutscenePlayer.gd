extends VideoStreamPlayer


func _ready():
	pass # Replace with function body.

# Godot 4 plays only Ogg Theora: the cutscenes are .ogv files, transcoded from the old .webm ones.
func play_cutscene(path):
	var file = "res://cutscenes/"+path+".ogv"
	if not ResourceLoader.exists(file):
		print("no cutscene " + path)
		hide()
		return
	show()
	self.set_stream(load(file))
	play()


func _on_CutscenePlayer_finished():
	hide()
