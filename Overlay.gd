extends Control

var server = WebSocketServer.new()
var client_id = 0

var compact_state = false
var current_race = ""

const TechPanel_Protoss = preload("res://tech panel/TechPanel_Protoss.tscn")
const TechPanel_Terran = preload("res://tech panel/TechPanel_Terran.tscn")
const TechPanel_WoL = preload("res://tech panel/TechPanel_WoL.tscn")

func incoming_connection(_id, _proto):
	client_id = _id
	for node in $TechPanel/GridContainer.get_children():
		node.gray_out()
	disable_overlay()
	show()

func disconnection(_id, _wtf):
	$NoClientWarning.show()
	for node in $TechPanel/GridContainer.get_children():
		node.highlight()
		node.in_progress()

func incoming_message(id):
	var pkt = server.get_peer(id).get_packet()
	var s = pkt.get_string_from_utf8()
	
	$PingTimeout.start()
	
	if s=="ping" or s=="":
		return
	
	var json_parse = JSON.parse(s.substr(5))
	var json
	if json_parse.error == OK:
		json = json_parse.result
	else:
		print("parsing error")
	
	if json.has("mode"):
		if json["mode"]=="compact":
			if not compact_state:
				compact_state = true
				$GameStats.reset_timer()
				$Effects.reset()
				$Leaderboards.hide()
				current_race = ""
			if json.has("race") and json["race"]=="terran":
				if current_race!="terran":
					current_race = "terran"
					remove_child($TechPanel)
					add_child(TechPanel_Terran.instance())
					move_child($TechPanel,0)				
					enable_overlay()
			if json.has("race") and json["race"]=="terran_wol":
				if current_race!="terran_wol":
					current_race = "terran_wol"
					remove_child($TechPanel)
					add_child(TechPanel_WoL.instance())
					move_child($TechPanel,0)
					enable_overlay()
			if json.has("race") and json["race"]=="protoss":
				if current_race!="protoss":
					current_race = "protoss"
					remove_child($TechPanel)
					add_child(TechPanel_Protoss.instance())
					move_child($TechPanel,0)				
					enable_overlay()
		else:
			compact_state = false			
			show()			
			$TechPanel.hide()
			$GGVote.hide()
			$NoClientWarning.hide()
			$GameStats.hide()
			$Leaderboards.update_state(json)
			$Leaderboards.show()			
			
	if json.has("stats"):
		$GameStats.update_state(json["stats"])
	
	if json.has("gameIntro"):
		$GameStats/GameIntro.update_state(json["gameIntro"])
		
	if json.has("creepingLine"):
		$GameStats.update_cline(json["creepingLine"])
	
	if json.has("playerStats"):
		$GameStats.update_pstats(json["playerStats"])
			
	if json.has("ggvote") and compact_state:
		$GGVote.set_value(int(json["ggvote"]))
	
	if json.has("armory_shop"):
		$ArmoryShop.update_state(json["armory_shop"])
		
	if json.has("zerg_shop"):
		$"LabShop Zerg".update_state(json["zerg_shop"])
		
	if json.has("protoss_shop"):
		$"LabShop Protoss".update_state(json["protoss_shop"])

	if json.has("mission_select"):
		$MissionSelect.update_state(json["mission_select"])
	
	if json.has("events"):
		for event in json["events"]:
			$EventBoard.push_event(event)
	
	if json.has("effect"):
		$Effects.launch(json["effect"])
	
	if json.has("micro"):
		$TechPanel/Background.micro(json["micro"])
	
	if json.has("upgrades"):
		var upgrades = json["upgrades"]		
		for node in $TechPanel/GridContainer.get_children():
			var sn = node.name
			if not upgrades.has(sn):
				node.gray_out()
		for key in upgrades.keys():
			if key != "type":
				var u = upgrades[key]
				if($TechPanel/GridContainer.has_node(key)):
					var node = $TechPanel/GridContainer.get_node(key)
					if u["enabled"]=="true":
						if u["state"]=="present":
							node.highlight()
						else:
							node.in_progress()
					else:
						node.gray_out()
					if u.has("quantity"):
						node.set_amount(int(u["quantity"]))
					if u.has("level"):
						node.set_level(int(u["level"]))
					

func _ready():
	server.connect("client_connected",self,"incoming_connection")
	server.connect("client_disconnected",self,"disconnection")	
	server.connect("data_received",self,"incoming_message")
	var _err = server.listen(14228)
	get_tree().get_root().set_transparent_background(true)
	OS.window_per_pixel_transparency_enabled = true
	$PingTimeout.start()

func _process(_delta):
	server.poll()

func enable_overlay():
	$TechPanel.show()	
	for node in $TechPanel/GridContainer.get_children():
		node.gray_out()
	$MissionSelect.hide()
	$GameStats.show()	
	show()
	
func disable_overlay():
	$TechPanel.hide()		
	$GGVote.hide()
	$ArmoryShop.hide()
	$"LabShop Protoss".hide()
	$"LabShop Zerg".hide()
	$NoClientWarning.hide()
	$MissionSelect.hide()
	$GameStats.hide()
	hide()


func _on_cutscene_finished():
	$CutscenePlayer.hide()


func _on_PingTimeout():
	print("disconnected")
	server = WebSocketServer.new()
	server.connect("client_connected",self,"incoming_connection")
	server.connect("client_disconnected",self,"disconnection")	
	server.connect("data_received",self,"incoming_message")
	var _err = server.listen(14228)
	$PingTimeout.start()

