extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fade_in = false
var fade_out = false
var local_timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fadeIn():
	fade_in = true
	fade_out = false
	self.local_timer = 0.0
	self.margin_left = 0
	self.margin_right = 0
	self.modulate.a = 1.0

func fadeOut():
	fade_out = true
	fade_in = false

func update_state(json):
	$Container/Line1.text = json["intro"]
	$Container/Line2.text = json["opponent"]
	$Container/Line3.text = json["description"]
	var tip_text = json["tip"]
	
	tip_text = tip_text.replace("</span>", "[/color]")
	tip_text = tip_text.replace("<span class='command'>", "[color=#22DD22]")
	tip_text = tip_text.replace("<span class='unit-type'>", "[color=#DD8822]")
	
	$Container/Tip.bbcode_text = tip_text
	if json["fadeOut"]:
		fadeOut()
	else:
		fadeIn()
	
func _process(delta):
	if not fade_in and not fade_out:
		fade_in = true
	if fade_in:
		var speed = 500.0
		local_timer += delta
		if local_timer > 15.0:
			fadeOut()
		if self.margin_left >= -500:
			self.margin_left -= delta*speed
		if self.margin_right <= 500:
			self.margin_right += delta*speed
	if fade_out:
		var speed = 0.5
		if self.modulate.a>0:
			self.modulate.a -= speed*delta
