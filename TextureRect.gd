extends TextureRect

@export var TBronze: Texture2D
@export var TSilver: Texture2D
@export var TGold: Texture2D
@export var TPlatinum: Texture2D
@export var TDiamond: Texture2D
@export var TMaster: Texture2D
@export var TGM: Texture2D

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
