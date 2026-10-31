extends VideoStreamPlayer


func _ready():
	pass # Replace with function body.

# Godot 4 plays only Ogg Theora: the cutscenes are .ogv files, transcoded from the old .webm ones.
# They are not in git, and too large for an export, so an exported overlay finds them in a folder
# next to it. In the editor the executable is Godot, and they are in the project.
func play_cutscene(path):
	var file = OS.get_executable_path().get_base_dir()+"/cutscenes/"+path+".ogv"
	if not FileAccess.file_exists(file):
		file = "res://cutscenes/"+path+".ogv"
	if not FileAccess.file_exists(file):
		print("no cutscene " + path)
		hide()
		return
	show()
	var video = VideoStreamTheora.new()
	video.file = file
	self.set_stream(video)
	play()


func _on_CutscenePlayer_finished():
	hide()
