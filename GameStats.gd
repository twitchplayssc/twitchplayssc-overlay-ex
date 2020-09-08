extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_state(json):
	$APMCount/Value.text = json["apm"]
	$WLRatio/Value.text = json["gamesWon"] + String("/") + json["gamesLost"]
	$PlayerCount/Value.text = json["players"]
	$Level/Value.text = json["aiLevel"]

func update_cline(json):
	$CreepingLine/Label.text = json["text"]
	
func update_pstats(json):
	$PlayersTable/Column_UnitsKilled.update_state(json["topUnitsKilled"])
	$PlayersTable/Column_XP.update_state(json["xpGained"])
	
	
