extends PanelContainer

func reset():
	for node in $HBoxContainer/Badges.get_children():
		node.queue_free()
	hide()

func update_state(num, player):
	$HBoxContainer/Number.text = String(num)
	
	var position = String(player["globalRank"])
	var climb = String(player["climb"])
	if climb != "-":
		var ic = int(climb)
		if ic > 0:
			climb = "[color=#AAFFAA]+"+climb+"[/color]"
		else:
			climb = "[color=#FFAAAA]"+climb+"[/color]"
	$HBoxContainer/Position.bbcode_text = position + " (" + climb + ")"
	
	var max_badges = 3
	for badge in player["badges"]:
		var badge_node = $BadgesSmall.get_node(badge)
		$HBoxContainer/Badges.add_child(badge_node.duplicate())
		max_badges-=1
		if max_badges<=0:
			break
	
	$HBoxContainer/League/Icon.update_state(player["league"])
	$HBoxContainer/PlayerNameBar/PlayerName.text = player["name"]
	$HBoxContainer/Value.text = String(player["value"])
	
	show()
