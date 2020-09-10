extends Control

var active = false

func _ready():
	$Panel.rect_position.y = -100
	activate()	

func reset():
	for node in $Panel/HBoxContainer/Badges.get_children():
		node.queue_free()
	hide()
	$Panel.rect_position.y = -37
	active = false
	
func activate():
	active = true
	
func _process(delta):
	if active and $Panel.rect_position.y < 0:
		$Panel.rect_position.y += 100.0 * delta

func update_state(num, player):
	$Panel/HBoxContainer/Number.text = String(num)
	
	var position = String(player["globalRank"])
	var climb = String(player["climb"])
	if climb != "-":
		var ic = int(climb)
		if ic > 0:
			climb = "[color=#AAFFAA]+"+climb+"[/color]"
		else:
			climb = "[color=#FFAAAA]"+climb+"[/color]"
	$Panel/HBoxContainer/Position.bbcode_text = position + " (" + climb + ")"
	
	var max_badges = 3
	for badge in player["badges"]:
		var badge_node = $BadgesSmall.get_node(badge)
		$Panel/HBoxContainer/Badges.add_child(badge_node.duplicate())
		max_badges-=1
		if max_badges<=0:
			break
	
	$Panel/HBoxContainer/League/Icon.update_state(player["league"])
	$Panel/HBoxContainer/PlayerNameBar/PlayerName.text = player["name"]
	$Panel/HBoxContainer/Value.text = String(player["value"])
	$Panel.position.y = -37
	active = false
	show()
