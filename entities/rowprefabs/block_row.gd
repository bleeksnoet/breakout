extends Node2D

func _process(delta):
	if Global.moving == true:
		position.y += 64
