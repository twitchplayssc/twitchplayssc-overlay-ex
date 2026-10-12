extends Control

var active = false

func _ready():
	$Panel.position.y = -100
	activate()	

func reset():
	for node in $Panel/HBoxContainer/Badges.get_children():
		node.queue_free()
	hide()
	$Panel.position.y = -37
	active = false
	
func activate():
	active = true
	
func _process(delta):
	if active and $Panel.position.y < 0:
		$Panel.position.y += 200.0 * delta

func update_state(num, player):
	$Panel/HBoxContainer/Number.text = str(num)
	
	var rank = str(player["globalRank"])
	var climb = str(player["climb"])
	if climb != "-":
		var ic = int(climb)
		if ic > 0:
			climb = "[color=#AAFFAA]+"+climb+"[/color]"
		else:
			climb = "[color=#FFAAAA]"+climb+"[/color]"
	$Panel/HBoxContainer/Position.text = rank + " (" + climb + ")"
	
	var max_badges = 3
	for badge in player["badges"]:
		var badge_node = $BadgesSmall.get_node(badge)
		$Panel/HBoxContainer/Badges.add_child(badge_node.duplicate())
		max_badges-=1
		if max_badges<=0:
			break
	
	$Panel/HBoxContainer/League/Icon.update_state(player["league"])
	$Panel/HBoxContainer/PlayerNameBar/PlayerName.text = player["name"]
	$Panel/HBoxContainer/Value.text = str(player["value"])
	$Panel.position.y = -37
	active = false
	show()
