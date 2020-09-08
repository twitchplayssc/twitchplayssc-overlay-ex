extends TextureRect

export (Texture) var TBronze
export (Texture) var TSilver
export (Texture) var TGold
export (Texture) var TPlatinum
export (Texture) var TDiamond
export (Texture) var TMaster
export (Texture) var TGM

func update_state(league):
	match league:
		"Bronze":
			texture = TBronze
		"Silver":
			texture = TSilver
		"Gold":
			texture = TGold
		"Platinum":
			texture = TPlatinum
		"Diamond":
			texture = TDiamond
		"Master":
			texture = TMaster
		"Grandmaster":
			texture = TGM

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
