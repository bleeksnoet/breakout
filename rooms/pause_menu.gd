extends Control


func _on_main_menu_pressed():
	$Confirm.show()
	$Cancel.show()
	$Label.show()
	$MainMenu.hide()

func _on_continue_pressed():
	get_tree().paused = false
	hide()

func _on_confirm_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/start_menu.tscn")
	
func _on_cancel_pressed() -> void:
	$Confirm.hide()
	$Cancel.hide()
	$Label.hide()
	$MainMenu.show()
