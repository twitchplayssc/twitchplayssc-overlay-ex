extends Control

var timer_seconds = 0
var timer_minutes = 0
var timer_hours = 0

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
	
	
func reset_timer():
	timer_seconds=0
	timer_minutes=0
	timer_hours=0

func _on_Second():
	timer_seconds+=1
	if timer_seconds>=60:
		timer_seconds=0
		timer_minutes+=1
		if timer_minutes>=60:
			timer_minutes = 0
			timer_hours+=1
	elif timer_seconds<0:
		timer_seconds=0
		timer_minutes-=1
		if timer_minutes<0:
			timer_minutes=0
			timer_hours-=1
	if get_parent().has_node("TechPanel/Timer"):
		get_parent().get_node("TechPanel/Timer").text = String(timer_hours)+":"+String(timer_minutes+100).right(1)+":"+String(timer_seconds+100).right(1)
	
