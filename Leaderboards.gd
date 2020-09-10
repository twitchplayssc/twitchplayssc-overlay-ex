extends Control

func _ready():
	$Screen1/MVP/MVPLeague/Scale/LeagueIcon.update_state("Grandmaster")
	
func update_state(json):
	var game = json["game"]
	$Screen1/VictoryLabel.text = game["result"]
	$Screen1/MapInfo.text = game["map"] + " - " + game["opponent"] + " - " + game["duration"]
	var mvp = json["mvp"]	
	$Screen1/MVP/MVPName.text = mvp["player"]
	$Screen1/MVP/MVPLeague/Scale/LeagueIcon.update_state(mvp["league"])
		
	var i = 0
	for board in json["gameleaderboards"]:
		var node = $Screen1/LB_Grid.get_child(i)
		node.update_state(board)
		node.set_timer(float(i))
		i+=1
	
	i = 0
	for board in json["globalLeaderboards"]:
		var node = $Screen2/LB_Grid.get_child(i)
		node.update_state(board)
		i+=1
	
	$Screen1.show()
	$Screen2.hide()
	$Screen1_Wait.start()


func _on_screen1_timeout():
	$Screen1.hide()
	$Screen2.show()
