extends VideoPlayer


func _ready():
	pass # Replace with function body.

func play_cutscene(path):
	show()
	var nstream = VideoStreamWebm.new()
	nstream.set_file("res://cutscenes/"+path+".webm")
	self.set_stream(nstream)
	play()


func _on_CutscenePlayer_finished():
	hide()
