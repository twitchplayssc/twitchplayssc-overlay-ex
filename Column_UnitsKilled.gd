extends Control

func update_stats(json):
	$VBoxContainer/PlayerLine1/PlayerName.text = json[0]["name"]
	$VBoxContainer/PlayerLine1/Value.text = String(json[0]["count"])
	$VBoxContainer/PlayerLine2/PlayerName.text = json[1]["name"]
	$VBoxContainer/PlayerLine2/Value.text = String(json[1]["count"])
	$VBoxContainer/PlayerLine3/PlayerName.text = json[2]["name"]
	$VBoxContainer/PlayerLine3/Value.text = String(json[2]["count"])
	$VBoxContainer/PlayerLine4/PlayerName.text = json[3]["name"]
	$VBoxContainer/PlayerLine4/Value.text = String(json[3]["count"])
	$VBoxContainer/PlayerLine5/PlayerName.text = json[4]["name"]
	$VBoxContainer/PlayerLine6/Value.text = String(json[4]["count"])
	
