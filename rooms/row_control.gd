extends Node

@onready var Level = $"."

@onready var spawnrow = preload("res://entities/rowprefabs/block_row.tscn")

func RowCheck():
	var diceroll = randi_range(1,10)
	print("rolled a ", diceroll)
	print("spawning normal row")
	var r = spawnrow.instantiate()
	add_child(r)
	r.transform = $blocks/RowSpawner.global_transform
	Level.Count = 0
