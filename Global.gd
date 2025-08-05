extends Node

#FIXME parrying is unreliable
#TODO overhaul UI
#TODO background music
#TODO gunblock
#TODO animations
#TODO more difficulty ranges
#TODO HoloBlock
#TODO longer paddle powerup
#TODO shorter paddle powerdown(?)
#TODO Faster paddle powerup
#TODO slower paddle powerdown
#TODO level events
#TODO how to play page
#TODO settings button at main menu

var highscores: Dictionary

var difficultychancebonus = 0
var maxchancebonus = 20
var scorepoints = 0
var combo = false
var moving = false
var Gunpower = 0
var MaxGunpower = 99
var BallPower = 0
var MaxBallPower = 99
var BonusLives = 0
var MaxBonusLives = 99
var BonusBall = true
var savepath = "user://savefile.json"
var savepathhighscores = "user://scores.save"
var difficulty = 0
var difficultytreshold = 5
var ProgbarCap = 10
var level = 1
var parried = false
var BallCount = 0

enum selectablepowerups {Gun, Ball, Parry}
var selectedpowerup = selectablepowerups.Parry

func _init() -> void:
	LoadGame()

func SaveGame():
	SaveHighscores()
	var SaveData = {
		"difficultychancebonus" = difficultychancebonus,
		"maxchancebonus" = maxchancebonus,
		"scorepoints"= scorepoints,
		"Gunpower" = Gunpower,
		"BallPower" = BallPower,
		"BonusLives" = BonusLives,
		"difficulty" = difficulty,
		"difficultytreshold" = difficultytreshold,
		"ProgbarCap" = ProgbarCap,
		"level" = level
	}
	var JsonString = JSON.stringify(SaveData)
	var SaveFile = FileAccess.open(savepath,FileAccess.WRITE)
	if SaveFile:
		SaveFile.store_string(JsonString)
		SaveFile.close()

func LoadGame():
	LoadHighschores()
	if FileAccess.file_exists(savepath):
		var SaveFile = FileAccess.open(savepath, FileAccess.READ)
		var Content = SaveFile.get_as_text()
		SaveFile.close()
		var SaveData = JSON.parse_string(Content)
		if typeof(SaveData) == TYPE_DICTIONARY:
			difficultychancebonus = SaveData.get("difficultychancebonus", difficultychancebonus)
			maxchancebonus = SaveData.get("maxchancebonus", maxchancebonus)
			scorepoints = SaveData.get("scorepoints", scorepoints)
			Gunpower = SaveData.get("Gunpower", Gunpower)
			BallPower = SaveData.get("BallPower", BallPower)
			BonusLives = SaveData.get("BonusLives", BallPower)
			difficulty = SaveData.get("difficulty", difficulty)
			difficultytreshold = SaveData.get("difficultytreshold", difficultytreshold)
			ProgbarCap = SaveData.get("ProgbarCap", ProgbarCap)
			level = SaveData.get("level", level)
			
	else:
		print("No file found :c")
		return

func SaveHighscores():
	var scorefile = FileAccess.open(savepathhighscores, FileAccess.WRITE)
	var ToJson = JSON.stringify(highscores)
	if scorefile:
		scorefile.store_string(ToJson)
		scorefile.close()
		print("higscore saved")

func LoadHighschores():
	if FileAccess.file_exists(savepathhighscores):
		var scorefile = FileAccess.open(savepathhighscores, FileAccess.READ)
		if scorefile:
			var JsonText = scorefile.get_as_text()
			var result = JSON.parse_string(JsonText)
			if typeof(result) == TYPE_DICTIONARY:
				highscores = result
				print("scores loaded!")
				print(highscores)
			else:
				print("something fucky with the highscores")
			scorefile.close()
	else:
		highscores.clear()

func ResetGame():
	print("file reset")
	if FileAccess.file_exists(savepath):
		var Dir = DirAccess.open("user://")
		if Dir:
			Dir.remove("savefile.json")
			ResetValues()
	if FileAccess.file_exists(savepathhighscores):
		var Dir = DirAccess.open("user://")
		if Dir:
			Dir.remove("scores.save")
			print("scores removed")
			
	highscores.clear()
	SaveGame()

func ResetValues():
	difficultychancebonus = 0
	maxchancebonus = 20
	scorepoints = 0
	Gunpower = 0
	BallPower = 0
	BonusLives = 0
	difficulty = 0
	difficultytreshold = 5
	level = 1
	ProgbarCap = 10
