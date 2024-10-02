extends Control

var server = WebSocketServer.new()
var client_id = 0

var compact_state = false
var current_race = ""

const TechPanel_Protoss = preload("res://tech panel/TechPanel_Protoss.tscn")
const TechPanel_Terran = preload("res://tech panel/TechPanel_Terran.tscn")
const TechPanel_Zerg = preload("res://tech panel/TechPanel_Zerg.tscn")
const TechPanel_WoL = preload("res://tech panel/TechPanel_WoL.tscn")
const TechPanel_Mixed = preload("res://tech panel/TechPanel_Generic.tscn")

func incoming_connection(_id, _proto):
	client_id = _id
	for node in $TechPanel/GCC/GridContainer.get_children():
		node.gray_out()
	disable_overlay()
	show()

func disconnection(_id, _wtf):
	$NoClientWarning.show()
	for node in $TechPanel/GCC/GridContainer.get_children():
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
					reset_tech()
			if json.has("race") and json["race"]=="terran_wol":
				if current_race!="terran_wol":
					current_race = "terran_wol"
					remove_child($TechPanel)
					add_child(TechPanel_WoL.instance())
					move_child($TechPanel,0)
					reset_tech()
			if json.has("race") and json["race"]=="protoss":
				if current_race!="protoss":
					current_race = "protoss"
					remove_child($TechPanel)
					add_child(TechPanel_Protoss.instance())
					move_child($TechPanel,0)
					reset_tech()
			if json.has("race") and json["race"]=="zerg":
				if current_race!="zerg":
					current_race = "zerg"
					remove_child($TechPanel)
					add_child(TechPanel_Zerg.instance())
					move_child($TechPanel,0)
					reset_tech()
			if json.has("race") and json["race"]=="mixed":
				if current_race!="mixed":
					current_race = "mixed"
					remove_child($TechPanel)
					add_child(TechPanel_Mixed.instance())
					move_child($TechPanel,0)
					reset_tech()
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
			$Tutorial.deactivate()	
			
	if json.has("stats"):
		$GameStats.update_state(json["stats"])
	
	if json.has("gameIntro"):
		$GameStats/GameIntro.update_state(json["gameIntro"])
		$CutscenePlayer.hide()
		
	if json.has("cine_path"):
		$CutscenePlayer.play_cutscene(json["cine_path"])
		
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
		
	if json.has("tutorial"):
		$Tutorial.activate(json["tutorial"])
		
	if json.has("tutorial_off"):
		$Tutorial.deactivate()
	
	if json.has("upgrades"):
		var upgrades = json["upgrades"]		
		for node in $TechPanel/GCC/GridContainer.get_children():
			var sn = node.name
			if not upgrades.has(sn):
				node.gray_out()
		var q_lair = 0
		var q_hatch = 0
		var q_hive = 0
		var q_spire = 0
		var q_gspire = 0
		var b_hatch_enabled = false
		var b_hatch_progress = false
		var b_lair_enabled = false
		var b_lair_progress = false
		var b_hive_enabled = false
		var b_hive_progress = false
		var b_spire_enabled = false
		var b_spire_progress = false
		var b_gspire_enabled = false
		var b_gspire_progress = false
		for key in upgrades.keys():
			if key != "type":
				var u = upgrades[key]
				var b_enabled = false
				if u["enabled"]=="true":
					b_enabled = true
				var b_progress = false
				if u["state"]!="present":
					b_progress = true								
				if key == "hatchery":
					q_hatch+=int(u["quantity"])
					b_hatch_enabled = b_enabled
					b_hatch_progress = b_progress
				if key == "lair":
					q_lair+=int(u["quantity"])
					b_lair_enabled = b_enabled
					b_lair_progress = b_progress
				if key == "hive":
					q_hive+=int(u["quantity"])
					b_hive_enabled = b_enabled
					b_hive_progress = b_progress
				if key == "spire":
					q_spire+=int(u["quantity"])
					b_spire_enabled = b_enabled
					b_spire_progress = b_progress
				if key == "gspire":
					q_gspire+=int(u["quantity"])
					b_gspire_enabled = b_enabled
					b_gspire_progress = b_progress
				if($TechPanel/GCC/GridContainer.has_node(key)):
					var node = $TechPanel/GCC/GridContainer.get_node(key)
					if u["enabled"]=="true":
						if u["state"]=="present" or u["state"]=="star":
							if $TechPanel/GCC/GridContainer.has_node("unit_spectre") and $TechPanel/GCC/GridContainer.has_node("unit_ghost"):
								if key == "unit_ghost":
									$TechPanel/GCC/GridContainer.get_node("unit_spectre").hide()
									$TechPanel/GCC/GridContainer.get_node("unit_ghost").show()
								if key == "unit_spectre":
									$TechPanel/GCC/GridContainer.get_node("unit_ghost").hide()
									$TechPanel/GCC/GridContainer.get_node("unit_spectre").show()	
							node.highlight()
							if u["state"]=="star":
								node.show_star()
						else:
							node.in_progress()
					else:
						node.gray_out()
					if u.has("quantity"):
						node.set_amount(int(u["quantity"]))
					if u.has("level"):
						node.set_level(int(u["level"]))
		if $TechPanel/GCC/GridContainer.has_node("hive_"):
			if q_hatch>0:
				$TechPanel/GCC/GridContainer.get_node("hive_").set_level(0)
			if q_lair>0:
				$TechPanel/GCC/GridContainer.get_node("hive_").set_level(1)
			if q_hive>0:
				$TechPanel/GCC/GridContainer.get_node("hive_").set_level(2)
			if q_spire>0:
				$TechPanel/GCC/GridContainer.get_node("spire_").set_level(0)
			if q_gspire>0:
				$TechPanel/GCC/GridContainer.get_node("spire_").set_level(1)
			if !b_hive_enabled:
				b_hive_enabled = b_lair_enabled
				b_hive_progress = b_lair_progress
			if !b_hive_enabled:
				b_hive_enabled = b_hatch_enabled
				b_hive_progress = b_hatch_progress
			if !b_gspire_enabled:
				b_gspire_enabled = b_spire_enabled
				b_gspire_progress = b_spire_progress
			var q_base = q_hatch + q_lair + q_hive
			q_spire += q_gspire
			if b_hive_enabled:
				$TechPanel/GCC/GridContainer.get_node("hive_").set_amount(q_base)
				if !b_hive_progress:
					$TechPanel/GCC/GridContainer.get_node("hive_").highlight()
				else:
					$TechPanel/GCC/GridContainer.get_node("hive_").in_progress()
		if $TechPanel/GCC/GridContainer.has_node("spire_"):
			if b_gspire_enabled:
				$TechPanel/GCC/GridContainer.get_node("spire_").set_amount(q_spire)
				if !b_gspire_progress:
					$TechPanel/GCC/GridContainer.get_node("spire_").highlight()
				else:
					$TechPanel/GCC/GridContainer.get_node("spire_").in_progress()
			

func _ready():
	#$CutscenePlayer.play_cutscene("WOL_R01_outro")
	
	server.connect("client_connected",self,"incoming_connection")
	server.connect("client_disconnected",self,"disconnection")	
	server.connect("data_received",self,"incoming_message")
	var _err = server.listen(14228)
	get_tree().get_root().set_transparent_background(true)
	OS.window_per_pixel_transparency_enabled = true
	$PingTimeout.start()
	

func _process(_delta):
	server.poll()

func reset_tech():
	for node in $TechPanel/GCC/GridContainer.get_children():
		node.gray_out()
	
func enable_overlay():
	$TechPanel.show()	
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

func _on_PingTimeout():
	print("disconnected")
	server = WebSocketServer.new()
	server.connect("client_connected",self,"incoming_connection")
	server.connect("client_disconnected",self,"disconnection")	
	server.connect("data_received",self,"incoming_message")
	var _err = server.listen(14228)
	$PingTimeout.start()

