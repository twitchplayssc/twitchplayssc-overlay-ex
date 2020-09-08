extends PanelContainer

var style = StyleBoxFlat.new()

func ready():
	add_stylebox_override("panel", style)

func reset():
	for node in $HBoxContainer/Badges.get_children():
		node.queue_free()
	hide()

func update_state(num, player):
	$HBoxContainer/Number.text = String(num)
	
	if player.has("highlight") and player["highlight"] == "true":
		style.set_bg_color(Color("55AAFF"))
	else:
		style.set_bg_color(Color("#005572"))		
	var max_badges = 5
	for badge in player["badges"]:
		var badge_node = $BadgesSmall.get_node(badge)
		$HBoxContainer/Badges.add_child(badge_node.duplicate())
		max_badges-=1
		if max_badges<=0:
			break
	update()
	$HBoxContainer/League/Icon.update_state(player["league"])
	$HBoxContainer/PlayerNameBar/PlayerName.text = player["name"]
	$HBoxContainer/Value.text = String(player["value"])
	
	show()
