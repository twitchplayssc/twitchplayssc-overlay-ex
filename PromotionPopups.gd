extends Control

# Popups for the players the last game promoted to a higher league, one each, stacked up the right
# edge of the screen from its bottom, so that several fit, the middle stays clear, and on the
# leaderboards they cover the lowest ranks rather than the top. They slide in one after another,
# a little apart; the ones beyond what fits at once wait for a place.

const PromotionPopup = preload("res://PromotionPopup.tscn")
const SubName = preload("res://SubName.gd")

const BOTTOM = 1060.0
const MARGIN = 24.0
const GAP = 10.0
const STAGGER = 0.6
const SLIDE_TIME = 0.5
const MOVE_TIME = 0.3
const FADE_TIME = 0.4
const SHOW_TIME = 8.0
const MAX_SHOWN = 6
const MAX_WAITING = 30

var waiting = []
var shown = []
var next_in = 0.0

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func launch(promotions):
	for promotion in promotions:
		if waiting.size() < MAX_WAITING:
			waiting.append(promotion)

func _process(delta):
	if next_in > 0.0:
		next_in -= delta
	if waiting.is_empty() or next_in > 0.0 or shown.size() >= MAX_SHOWN:
		return
	show_popup(waiting.pop_front())
	next_in = STAGGER

func show_popup(promotion):
	var popup = PromotionPopup.instantiate()
	add_child(popup)
	var league = str(promotion.get("league", ""))
	popup.get_node("Box/Name").text = str(promotion.get("name", ""))
	SubName.apply(popup.get_node("Box/Name"), SubName.is_sub(promotion))
	popup.get_node("Box/Text").text = "promoted to " + league + " League"
	popup.get_node("Box/Icon/LeagueIcon").update_state(league)
	popup.reset_size()
	var width = get_viewport_rect().size.x
	shown.append(popup)
	popup.position = Vector2(width, slot_y(shown.size() - 1))

	var tween = popup.create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "position:x", width - popup.size.x - MARGIN, SLIDE_TIME)
	tween.tween_interval(SHOW_TIME)
	tween.tween_property(popup, "modulate:a", 0.0, FADE_TIME)
	tween.tween_callback(remove_popup.bind(popup))

# Where the popup in the given place goes: above those before it.
func slot_y(index):
	var y = BOTTOM
	for i in range(index + 1):
		y -= shown[i].size.y
		if i > 0:
			y -= GAP
	return y

# The popups above the one that leaves move down into its place.
func remove_popup(popup):
	shown.erase(popup)
	popup.queue_free()
	for i in range(shown.size()):
		var tween = shown[i].create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(shown[i], "position:y", slot_y(i), MOVE_TIME)
