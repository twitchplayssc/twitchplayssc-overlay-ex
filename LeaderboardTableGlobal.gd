extends PanelContainer

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
	$Table/LeaderboardEntry11.reset()
	$Table/LeaderboardEntry12.reset()
	$Table/LeaderboardEntry13.reset()
	$Table/LeaderboardEntry14.reset()
	$Table/LeaderboardEntry15.reset()
	$Table/LeaderboardEntry16.reset()
	$Table/LeaderboardEntry17.reset()
	$Table/LeaderboardEntry18.reset()
	$Table/LeaderboardEntry19.reset()
	$Table/LeaderboardEntry20.reset()
	$Table/LeaderboardEntry21.reset()
	$Table/LeaderboardEntry22.reset()
	$Table/LeaderboardEntry23.reset()
	$Table/LeaderboardEntry24.reset()
	$Table/LeaderboardEntry25.reset()
	
	for player in board["players"]:
		$Table.get_child(i).update_state(i, player)
		i+=1

func _ready():
	pass # Replace with function body.

