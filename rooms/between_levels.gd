extends Node2D

@onready var Scorelabel = $Score

func _ready():
	Scorelabel.text = str("Score: ", Global.scorepoints)
	
#func _on_quit_pressed():


func _on_continue_pressed():
	print("work")
	var GameRoom = preload("res://rooms/level.tscn")
	Global.SaveGame()
	get_tree().change_scene_to_packed(GameRoom)

func _on_quit_pressed() -> void:
	Global.SaveGame()
	get_tree().change_scene_to_file("res://rooms/start_menu.tscn")
