extends Node2D

var highscores = Global.highscores
@onready var scorepanel = preload("res://scoringsystem/label.tscn")

func _ready() -> void:
	get_tree().paused = false
	print("---menu---")
	var order = OrderHighScores(highscores)
	DrawScoresonUI(order)

func _on_start_pressed():
	$Selectsound.playing = true
	print("loading game...")
	$SceneTrans.Start()

func _on_quit_pressed():
	$Selectsound.playing = true
	Global.SaveGame()
	get_tree().quit()

func _on_button_pressed():
	Global.ResetGame()
	get_tree().reload_current_scene()

#highscore stuff
func OrderHighScores(score_dict: Dictionary) -> Dictionary:
	var entries := score_dict.duplicate()
	var sorted_keys := entries.keys()
	sorted_keys.sort_custom(func(a, b): return entries[a] > entries[b])

	var ordered := {}
	for key in sorted_keys:
		ordered[key] = entries[key]
	print("scores ordered!")
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

#func DrawScoresonUI(highscores):
	#for i in $HighscorePanel/ScrollContainer/VBoxContainer.get_child_count():
		#if get_child(i) != null:
			#$HighscorePanel/ScrollContainer/VBoxContainer.get_child(i).queue_free()
	#
	#for entry in highscores.keys():
		#var panel = scorepanel.instantiate()
		#panel.text = entry + " : " + str(highscores[entry])
		#$HighscorePanel/ScrollContainer/VBoxContainer.add_child(panel)
