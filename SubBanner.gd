extends PanelContainer

# A short banner at the top of the screen when someone subscribes, resubscribes or gifts subs.
# It stays clear of the middle of the screen, which in a game is what viewers are playing on.
# Banners that come while one shows wait their turn.

const SHOWN_Y = 110.0
const HIDDEN_Y = 40.0
const SLIDE_TIME = 0.4
const SHOW_TIME = 6.0
# Only so many wait: a gift of many subs is one banner, but a burst of resubs could pile up.
const MAX_WAITING = 10

var waiting = []
var playing = false

func _ready():
	hide()
	modulate.a = 0.0

func launch(text):
	if waiting.size() >= MAX_WAITING:
		return
	waiting.append(text)
	if not playing:
		play_next()

func play_next():
	if waiting.is_empty():
		playing = false
		hide()
		return
	playing = true
	$Text.text = waiting.pop_front()
	show()
	# A shorter text than the last leaves the banner at the last one's width otherwise.
	reset_size()
	position = Vector2((get_viewport_rect().size.x - size.x) / 2.0, HIDDEN_Y)
	modulate.a = 0.0

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", SHOWN_Y, SLIDE_TIME)
	tween.parallel().tween_property(self, "modulate:a", 1.0, SLIDE_TIME)
	tween.tween_interval(SHOW_TIME)
	tween.tween_property(self, "modulate:a", 0.0, SLIDE_TIME)
	tween.tween_callback(play_next)
