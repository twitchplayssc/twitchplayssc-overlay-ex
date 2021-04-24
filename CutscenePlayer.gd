extends VideoPlayer


func _ready():
	pass # Replace with function body.

func play_cutscene(path):
	#stream = VideoStreamWebm.new()
	stream.set_file("res://cutscenes/"+path+".webm")
	play()
	pass
