extends Control

var server = WebSocketServer.new()
var client_id = 0

func incoming_connection(_id, _proto):
	client_id = _id
	for node in $TechPanel/GridContainer.get_children():
		node.gray_out()
	$GGVote.hide()	

func disconnection(_id):
	for node in $TechPanel/GridContainer.get_children():
		node.highlight()
		node.in_progress()

func incoming_message(id):
	var pkt = server.get_peer(id).get_packet()
	var s = pkt.get_string_from_utf8()
	var json = JSON.parse(s.substr(5)).result
	
	if json.has("mode"):
		if json["mode"]=="compact":
			if json.has("race") and json["race"]=="terran":
				enable_overlay()
		else:
			disable_overlay()
	if json.has("ggvote"):
		$GGVote.set_value(int(json["ggvote"]))
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

func _process(_delta):
	server.poll()

func enable_overlay():
	for node in $TechPanel/GridContainer.get_children():
		node.gray_out()
	show()
	
func disable_overlay():
	$GGVote.hide()
	hide()
