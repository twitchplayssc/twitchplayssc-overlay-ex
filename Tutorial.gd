extends PanelContainer

const SHOWN_X = 10.0
const HIDDEN_X = -700.0
const SLIDE_TIME = 0.35
# The bot takes the tip off itself. This is for when it cannot, having stopped or lost the connection.
const HIDE_GRACE = 2.0

var slide = null
var countdown = null

func activate(text, player = "", seconds = 0.0):
	$Box/Header.text = "Tip for " + player
	$Box/Header.visible = player != ""
	$Box/Tip.text = text
	show()
	# A shorter tip than the last leaves the panel at the last one's height otherwise.
	reset_size()
	slide_to(SHOWN_X, 1.0)

	if countdown:
		countdown.kill()
	$HideTimer.stop()
	$Box/Time.visible = seconds > 0.0
	if seconds > 0.0:
		$Box/Time/Bar.anchor_right = 1.0
		countdown = create_tween()
		countdown.tween_property($Box/Time/Bar, "anchor_right", 0.0, seconds)
		$HideTimer.start(seconds + HIDE_GRACE)

func deactivate():
	$HideTimer.stop()
	if visible:
		slide_to(HIDDEN_X, 0.0).tween_callback(hide)

func slide_to(x, alpha):
	if slide:
		slide.kill()
	slide = create_tween()
	slide.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	slide.parallel().tween_property(self, "position:x", x, SLIDE_TIME)
	slide.parallel().tween_property(self, "modulate:a", alpha, SLIDE_TIME)
	return slide

func _ready():
	position.x = HIDDEN_X
	modulate.a = 0.0
	$HideTimer.timeout.connect(deactivate)
