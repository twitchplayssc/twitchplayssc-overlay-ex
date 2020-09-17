extends PanelContainer

var next_entry = 1

func set_timer(delay):
	$Delay.wait_time = delay+0.01
	$Delay.start()

func update_state(board):
	$Table/Header.text = board["title"]
	var i = 1
	
	$Table/LeaderboardEntry1.reset()
	$Table/LeaderboardEntry2.reset()
	$Table/LeaderboardEntry3.reset()
	$Table/LeaderboardEntry4.reset()
	$Table/LeaderboardEntry5.reset()
	$Table/LeaderboardEntry6.reset()
	$Table/LeaderboardEntry7.reset()
	$Table/LeaderboardEntry8.reset()
	$Table/LeaderboardEntry9.reset()
	$Table/LeaderboardEntry10.reset()
	
	next_entry = 0
	
	for player in board["players"]:
		if i>= $Table.get_child_count():
			break
		$Table.get_child(i).update_state(i, player)
		i+=1
		next_entry+=1

func _ready():
	pass # Replace with function body.

func _on_Delay_timeout():
	if next_entry > 0:
		$Table.get_child(next_entry).activate()
	if next_entry > 1:
		next_entry-=1
		$Delay.wait_time = 0.3
		$Delay.start()
