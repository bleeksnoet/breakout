extends Control

@onready var Scorelabel = $Score

@onready var scorepanel = preload("res://scoringsystem/label.tscn")

func _ready():
	#Global.LoadHighschores()
	var order = OrderHighScores(Global.highscores)
	DrawScoresonUI(order)

func _process(delta):
	Scorelabel.text = str("Score: ", Global.scorepoints)

func _on_try_again_pressed():
	Global.ResetValues()
	Global.SaveGame()
	#OrderHighScores(Global.highscores)
	hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://rooms/level.tscn")
	

func _on_quit_pressed():
	print("---BREAK---")
	Global.ResetValues()
	Global.SaveGame()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://rooms/start_menu.tscn")
	


#highscore stuff
func _on_line_edit_text_submitted(PlayerName):
	UpdateHighscores(PlayerName)
	
	var order = OrderHighScores(Global.highscores)
	DrawScoresonUI(order)
	
	Global.SaveGame()
	
	$Label3.text = str("Score saved!")

func UpdateHighscores(PlayerName):
	var name = PlayerName
	var submittedscore = Global.scorepoints
	Global.highscores[name] = submittedscore
	
	while Global.highscores.size() > 5:
		var lowest_value: int = 9999
		for entry in Global.highscores:
			if Global.highscores[entry] < lowest_value:
				lowest_value = Global.highscores[entry]
		
		for logged in Global.highscores:
			if Global.highscores[logged] == lowest_value:
				Global.highscores.erase(logged)

func OrderHighScores(score: Dictionary) -> Dictionary:
	var sorted_keys = score.keys()
	sorted_keys.sort_custom(func(a, b): return score[b] - score[a])
	
	var ordered = {}
	for k in sorted_keys:
		ordered[k] = score[k]
	return ordered


#func OrderHighScores(score: Dictionary) -> Dictionary:
	#var OriginalDictionary: Dictionary = highscores.duplicate()
	#var OrderedDictionary: Dictionary
	#for i in OriginalDictionary.size():
		#var HighestScore: int = 0
		#for entry in OriginalDictionary:
			#if OriginalDictionary[entry] > HighestScore:
				#HighestScore = OriginalDictionary[entry]
		#OrderedDictionary[OriginalDictionary.find_key(HighestScore)] = HighestScore
		#OriginalDictionary.erase(OriginalDictionary.find_key(HighestScore))
	#return OrderedDictionary
func DrawScoresonUI(score_data: Dictionary):
	var container = $HighscorePanel/ScrollContainer/VBoxContainer
	
	for child in container.get_children():
		child.queue_free()
	
	for name in score_data.keys():
		var panel = scorepanel.instantiate()
		panel.text = name + " : " + str(score_data[name])
		container.add_child(panel)

#
#func DrawScoresonUI(highscores):
	#for i in $HighscorePanel/ScrollContainer/VBoxContainer.get_child_count():
		#if get_child(i) != null:
			#$HighscorePanel/ScrollContainer/VBoxContainer.get_child(i).queue_free()
	#
	#for entry in highscores.keys():
		#var panel = scorepanel.instantiate()
		#panel.text = entry + " : " + str(highscores[entry])
		#$HighscorePanel/ScrollContainer/VBoxContainer.add_child(panel)
