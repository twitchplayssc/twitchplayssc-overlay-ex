extends Panel

# The popup that opens a game in the middle of the screen: what is played, what to do, and a tip.
# It opens from a thin line, its lines come in one after another, and a band of light runs across
# the title; its border, glow and rule take the colour of the race played. It covers the game for
# those seconds, so it stays translucent and leaves on its own if the bot does not close it first.

const SHOW_TIME = 15.0
const FADE_TIME = 1.0
# Wider text than this is set smaller, so that a long title or line stays inside the panel.
const TEXT_WIDTH = 960.0
const ACCENTS = {
	"protoss": Color(0.35, 0.8, 1.0),
	"terran": Color(1.0, 0.45, 0.25),
	"terran_wol": Color(1.0, 0.45, 0.25),
	"zerg": Color(0.78, 0.42, 1.0),
}
const NEUTRAL = Color(0.6, 0.66, 1.0)
const HIGHLIGHT = Color(1.0, 0.85, 0.5)
const BACKGROUND = Color(0.035, 0.045, 0.07, 0.78)

# The band of light: sweep is where its middle is, in the label's own pixels, and it leans a little.
const SWEEP_SHADER = """
shader_type canvas_item;

uniform float sweep = -1000.0;
uniform float band = 80.0;
varying vec2 local;

void vertex()
{
	local = VERTEX;
}

void fragment()
{
	float light = 1.0 - smoothstep(0.0, band, abs(local.x + local.y * 0.4 - sweep));
	COLOR.rgb = mix(COLOR.rgb, vec3(1.0), light * 0.8);
}
"""

var style = null
var accent = NEUTRAL
var tween = null
var pulse = null
var fading = false
var lines = []
var line_y = {}
var font_sizes = {}

func _ready():
	style = get_theme_stylebox("panel").duplicate()
	style.bg_color = BACKGROUND
	style.set_corner_radius_all(4)
	style.shadow_size = 14
	add_theme_stylebox_override("panel", style)
	lines = [$Container/Line1, $Container/Line2, $Container/Rule, $Container/Line3, $Container/Tip]
	for line in lines:
		line_y[line] = line.position.y
	for label in [$Container/Line1, $Container/Line2, $Container/Line3]:
		font_sizes[label] = label.get_theme_font_size("font_size")
	var material = ShaderMaterial.new()
	material.shader = Shader.new()
	material.shader.code = SWEEP_SHADER
	$Container/Line2.material = material
	# Nothing is shown until the bot opens a game.
	modulate.a = 0.0

func update_state(json, race = ""):
	if json["fadeOut"]:
		fadeOut()
		return
	$Container/Line1.text = json["intro"]
	$Container/Line2.text = json["opponent"]
	$Container/Line3.text = json["description"]
	var tip_text = json["tip"]

	tip_text = tip_text.replace("</span>", "[/color]")
	tip_text = tip_text.replace("<span class='command'>", "[color=#22DD22]")
	tip_text = tip_text.replace("<span class='unit-type'>", "[color=#DD8822]")

	$Container/Tip.text = tip_text
	for label in font_sizes:
		fit(label)
	paint(ACCENTS.get(race, NEUTRAL))
	fadeIn()

func fit(label):
	var font_size = font_sizes[label]
	var width = label.get_theme_font("font").get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	if width > TEXT_WIDTH:
		font_size = max(int(font_size * TEXT_WIDTH / width), 12)
	label.add_theme_font_size_override("font_size", font_size)

func paint(color):
	accent = color
	style.border_color = accent
	style.shadow_color = Color(accent, 0.3)
	$Container/Line1.add_theme_color_override("font_color", accent.lerp(Color.WHITE, 0.6))
	$Container/Line2.add_theme_color_override("font_shadow_color", Color(accent, 0.75))
	$Container/Line2.add_theme_constant_override("shadow_offset_x", 0)
	$Container/Line2.add_theme_constant_override("shadow_offset_y", 0)
	$Container/Line2.add_theme_constant_override("shadow_outline_size", 10)
	$Container/Line3.add_theme_color_override("font_color", HIGHLIGHT)
	$Container/Rule.modulate = accent

func stop():
	for running in [tween, pulse]:
		if running != null:
			running.kill()
	tween = null
	pulse = null

func fadeIn():
	stop()
	fading = false
	pivot_offset = size / 2.0
	scale = Vector2(0.0, 0.015)
	modulate.a = 1.0
	for line in lines:
		line.modulate.a = 0.0
	var title = $Container/Line2
	title.pivot_offset = title.size / 2.0
	$Container/Rule.pivot_offset = $Container/Rule.size / 2.0
	title.material.set_shader_parameter("sweep", -1000.0)

	tween = create_tween()
	tween.tween_property(self, "scale:x", 1.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale:y", 1.0, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# The lines come in together, each a little after the one above it.
	tween.tween_interval(0.01)
	var delay = 0.0
	for line in lines:
		tween.parallel().tween_property(line, "modulate:a", 1.0, 0.4).set_delay(delay)
		tween.parallel().tween_property(line, "position:y", line_y[line], 0.4).from(line_y[line] + 16.0).set_delay(delay) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		delay += 0.15
	tween.parallel().tween_property(title, "scale", Vector2.ONE, 0.5).from(Vector2(1.2, 1.2)).set_delay(0.15) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($Container/Rule, "scale:x", 1.0, 0.5).from(0.0).set_delay(0.3) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(sweep, -200.0, title.size.x + 300.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(start_pulse)
	tween.tween_interval(SHOW_TIME - 2.5)
	tween.tween_callback(fadeOut)

func sweep(x):
	$Container/Line2.material.set_shader_parameter("sweep", x)

# While the popup is up, its border and glow breathe slowly.
func start_pulse():
	pulse = create_tween().set_loops()
	pulse.tween_method(glow, 0.0, 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.tween_method(glow, 1.0, 0.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func glow(amount):
	style.border_color = accent.lerp(Color.WHITE, 0.35 * amount)
	style.shadow_color = Color(accent, 0.2 + 0.25 * amount)

func fadeOut():
	if fading or modulate.a <= 0.0:
		return
	stop()
	fading = true
	tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(0.96, 0.96), FADE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
