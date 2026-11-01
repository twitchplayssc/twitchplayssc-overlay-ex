extends Control

const SubName = preload("res://SubName.gd")

func update_state(json):
	$VBoxContainer/PlayerLine1/PlayerName.text = json[0]["name"]
	SubName.apply($VBoxContainer/PlayerLine1/PlayerName, SubName.is_sub(json[0]))
	$VBoxContainer/PlayerLine1/Value.text = str(json[0]["count"])
	$VBoxContainer/PlayerLine2/PlayerName.text = json[1]["name"]
	SubName.apply($VBoxContainer/PlayerLine2/PlayerName, SubName.is_sub(json[1]))
	$VBoxContainer/PlayerLine2/Value.text = str(json[1]["count"])
	$VBoxContainer/PlayerLine3/PlayerName.text = json[2]["name"]
	SubName.apply($VBoxContainer/PlayerLine3/PlayerName, SubName.is_sub(json[2]))
	$VBoxContainer/PlayerLine3/Value.text = str(json[2]["count"])
	$VBoxContainer/PlayerLine4/PlayerName.text = json[3]["name"]
	SubName.apply($VBoxContainer/PlayerLine4/PlayerName, SubName.is_sub(json[3]))
	$VBoxContainer/PlayerLine4/Value.text = str(json[3]["count"])
	$VBoxContainer/PlayerLine5/PlayerName.text = json[4]["name"]
	SubName.apply($VBoxContainer/PlayerLine5/PlayerName, SubName.is_sub(json[4]))
	$VBoxContainer/PlayerLine5/Value.text = str(json[4]["count"])
	
