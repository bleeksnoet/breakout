extends StaticBody2D
@export_category("blocktype")
@export var normal = true			#basic green
@export var toughblock = false		#frame 1, takes 2 hits
@export var brittleblock = false	#ball just goes right through
@export var gunblock = false		#has a gun on the bottom, shoots down from time to time
@export var metalblock = false		#takes 3 hits wowie!

var itemdropchance = 0
var pointbase = 0
var health = 0
var mult = 2

@onready var pointdrop = preload("res://entities/drops/bonuspoint.tscn")
@onready var gundrop = preload("res://entities/drops/GunpowerUp.tscn")
@onready var holoballs = preload("res://entities/drops/Holodrop.tscn")
@onready var bonushealth = preload("res://entities/drops/bonusheartdrop.tscn")
@onready var timer = $Timer
@onready var Sprite = $Sprite2D

var hit = false

func _ready():
	if normal == true:
		Sprite.frame = 0
		health = 1
		itemdropchance = 5
		pointbase = 1
	if toughblock == true:
		Sprite.frame = 1
		health = 2
		itemdropchance = 25
		pointbase = 2
	if brittleblock == true:
		Sprite.frame = 2
		health = 1
		pointbase = 1
		$CollisionShape2D.disabled = true
	if metalblock == true:
		Sprite.frame = 3
		health = 3
		itemdropchance = 50
		pointbase = 3

func _on_area_2d_body_entered(body):
	if normal == true:
		normalblockfunc()
	elif toughblock == true:
		toughblockfunc()
	elif brittleblock == true:
		brittleblockfunc()
	elif metalblock == true:
		metalblockfunc()

func _on_timer_timeout():
	health -= 1
	if health <= 0:
		queue_free()

func dropchance():
	var chance = randi_range(0,100) + Global.difficultychancebonus
	if chance <= itemdropchance:
		var choices = randi_range(0,4)
		if choices == 0:
			var r = pointdrop.instantiate()
			add_child(r)
			r.position = $spawn.position
			r.reparent(owner)
		if choices == 1:
			var r = gundrop.instantiate()
			add_child(r)
			r.position = $spawn.position
			r.reparent(owner)
		if choices == 3:
			var r = holoballs.instantiate()
			add_child(r)
			r.position = $spawn.position
			r.reparent(owner)
		if choices == 4:
			var r = bonushealth.instantiate()
			add_child(r)
			r.position = $spawn.position
			r.reparent(owner)

func normalblockfunc():
	if hit == false:
		dropchance()
		
		if Global.combo == false:
			Global.scorepoints += pointbase
			Global.combo = true
		else:
			Global.scorepoints += pointbase * mult
		timer.start()
		hit = true
	else:
		print("already hit")

func toughblockfunc():

	dropchance()
	
	if health <= 2:
		Sprite.frame = 0
		timer.start()
	if health <= 1:
		if Global.combo == false:
			Global.scorepoints += pointbase
			Global.combo = true
		else:
			Global.scorepoints += pointbase*2
		timer.start()

func brittleblockfunc():

	dropchance()
	
	if Global.combo == false:
		Global.scorepoints += pointbase
		Global.combo = true
	else:
		Global.scorepoints += pointbase*2
	timer.start()

func gunblockblockfunc():
	pass

func metalblockfunc():

	dropchance()
	
	if health <= 3:
		Sprite.frame = 1
		timer.start()
	if health <= 2:
		Sprite.frame = 0
		timer.start()
	if health <= 1:
		if Global.combo == false:
			Global.scorepoints += pointbase
			Global.combo = true
		else:
			Global.scorepoints += pointbase*2
		timer.start()
