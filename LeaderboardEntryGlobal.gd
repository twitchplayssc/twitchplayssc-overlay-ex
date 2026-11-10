extends PanelContainer

const SubName = preload("res://SubName.gd")

const DELTA_GAIN = Color(0.35, 0.9, 0.35)
const DELTA_LOSS = Color(1.0, 0.35, 0.3)
const DELTA_ZERO = Color(0.6, 0.6, 0.6)
const DELTA_GAP = 10.0

func ready():
	$BG_Highlight.hide()

func reset():
	for node in $HBoxContainer/Badges.get_children():
		node.queue_free()
	hide()

func update_state(num, player):
	$HBoxContainer/Number.text = str(num)
	
	if player.has("highlight") and player["highlight"] == "true":
		$BG_Highlight.show()
	else:
		$BG_Highlight.hide()
	var max_badges = 5
	for badge in player["badges"]:
		var badge_node = $BadgesSmall.get_node(badge)
		$HBoxContainer/Badges.add_child(badge_node.duplicate())
		max_badges-=1
		if max_badges<=0:
			break
	queue_redraw()
	$HBoxContainer/League/Icon.update_state(player["league"])
	$HBoxContainer/PlayerNameBar/PlayerName.text = player["name"]
	SubName.apply($HBoxContainer/PlayerNameBar/PlayerName, SubName.is_sub(player))
	$HBoxContainer/Value.text = str(player["value"])
	show_delta(player)
	
	show()

# What the last game changed the player's MMR by, right after their name: the bot sends it, as "+15" or
# "-8", only for the players that game rated.
func show_delta(player):
	var delta = $HBoxContainer/PlayerNameBar/Delta
	var text = str(player.get("delta", ""))
	if text == "":
		delta.hide()
		return
	var color = DELTA_ZERO
	if text.begins_with("-"):
		color = DELTA_LOSS
	elif text != "+0":
		color = DELTA_GAIN
	delta.text = text
	delta.add_theme_color_override("font_color", color)
	var name_label = $HBoxContainer/PlayerNameBar/PlayerName
	var font = name_label.get_theme_font("font")
	var font_size = name_label.get_theme_font_size("font_size")
	var width = font.get_string_size(name_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	delta.position.x = name_label.position.x + width + DELTA_GAP
	delta.show()
