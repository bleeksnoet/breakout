extends Button



func _on_pressed():
	var PlayRoom = preload("res://rooms/level.tscn")
	get_tree().change_scene_to_packed(PlayRoom)
