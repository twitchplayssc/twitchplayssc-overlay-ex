extends VideoPlayer


func _ready():
	pass # Replace with function body.

func play_cutscene(path):
	#stream = VideoStreamWebm.new()
	stream.resource_path = "res://cutscenes/"+path+".webm"
	play()
	pass
