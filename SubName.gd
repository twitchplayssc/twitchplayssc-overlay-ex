extends RefCounted

# Channel subscribers' names are drawn in bold. The bot marks their entries with "sub" : "1"; an
# entry without it is drawn as before.

const EMBOLDEN = 0.9

# One bold variation of each font a name is drawn in, made the first time it is needed.
static var bold_fonts = {}

static func is_sub(entry):
	return entry is Dictionary and str(entry.get("sub", "")) == "1"

# Labels are reused from one message to the next, so the font is set either way: the label's own
# font is kept the first time, and put back for a name that is not a subscriber's.
static func apply(label, sub):
	if not label.has_meta("plain_font"):
		label.set_meta("plain_font", label.get_theme_font("font"))
	var plain = label.get_meta("plain_font")
	label.add_theme_font_override("font", bold(plain) if sub else plain)

static func bold(font):
	if not bold_fonts.has(font):
		var variation = FontVariation.new()
		variation.base_font = font
		variation.variation_embolden = EMBOLDEN
		bold_fonts[font] = variation
	return bold_fonts[font]
