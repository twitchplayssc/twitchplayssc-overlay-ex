extends Control

var mvp_launched = false
var mvp_badge = 0
var mvp_current_badge = -1

func _ready():
	$Screen1/MVP/MVPLeague/Scale/LeagueIcon.update_state("Grandmaster")
	$Screen1/MVP.rect_position.x = 1920
	mvp_launched = false
	$MVP_Wait.start()
	$MVP_NextBadge.wait_time = 10.0
	$MVP_NextBadge.start()
	mvp_badge = 0
	mvp_current_badge = -1
	for node in $Screen1/MVP/CenterContainer/Badges.get_children():
		node.get_child(0).rect_scale.x = 0.0
	
func _process(delta):
	if $Screen1/MVP.rect_position.x > 32 and mvp_launched:
		$Screen1/MVP.rect_position.x -= 1000.0*delta
	if mvp_current_badge >= 0:
		var mvp_node = $Screen1/MVP/CenterContainer/Badges.get_child(mvp_current_badge)
		if mvp_node.get_child_count()>0:
			var node = mvp_node.get_child(0)
			if node != null and node.rect_scale.x < 1.0:
				node.rect_scale.x += delta*2.0
			else:
				mvp_current_badge = -1
		
	
func update_state(json):
	var game = json["game"]
	$Screen1/VictoryLabel.text = game["result"]
	$Screen1/MapInfo.text = game["map"] + " - " + game["opponent"] + " - " + game["duration"]
	var mvp = json["mvp"]	
	$Screen1/MVP/MVPName.text = mvp["player"]
	$Screen1/MVP/MVPLeague/Scale/LeagueIcon.update_state(mvp["league"])

	for node in $Screen1/MVP/CenterContainer/Badges.get_children():
		if node.get_child_count()>0:
			var nc = node.get_child(0)
			if nc != null:
				nc.queue_free()
		
	var badge_count = 0
	for badge in mvp["badges"]:
		var badge_node = $Screen1/MVP/BadgesLarge.get_node(badge["name"]).duplicate()
		badge_node.rect_scale.x = 0.0
		badge_node.rect_pivot_offset.x = 32
		$Screen1/MVP/CenterContainer/Badges.get_child(badge_count).add_child(badge_node)
		badge_count += 1

	var i = 0
	for board in json["gameleaderboards"]:
		var node = $Screen1/LB_Grid.get_child(i)
		node.update_state(board)
		node.set_timer(float(i))
		i+=1
	
	i = 0
	for board in json["globalLeaderboards"]:
		var node = $Screen2/LB_Grid.get_child(i)
		node.update_state(board)
		i+=1
		
	$Screen1/MVP.rect_position.x = 1920
	mvp_launched = false
	
	$Screen1.show()
	$Screen2.hide()
	$Screen1_Wait.start()
	$MVP_Wait.start()
	$MVP_NextBadge.wait_time = 10.0
	$MVP_NextBadge.start()
	mvp_badge = 0
	mvp_current_badge = -1
	


func _on_screen1_timeout():
	$Screen1.hide()
	$Screen2.show()


func _on_MVP_timeout():
	mvp_launched = true


func _on_MVP_NextBadge():
	mvp_current_badge = mvp_badge
	if mvp_badge < 14:
		mvp_badge+=1
		$MVP_NextBadge.wait_time=0.5
		$MVP_NextBadge.start()
