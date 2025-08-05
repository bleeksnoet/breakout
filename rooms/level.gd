extends Node2D

var Count = 0
var origin


#region blockrows

@onready var spawnrow = preload("res://entities/rowprefabs/block_row.tscn")
@onready var lvl2Row = preload("res://entities/rowprefabs/lvl2-block_row.tscn")
@onready var lvl2RowHard = preload("res://entities/rowprefabs/lvl2-block_rowHard.tscn")

#endregion

@onready var Fade = $SceneTrans
@onready var BallFreeze = $LostLifeTimer
@onready var Ball = $Ball
@onready var WallTimer = $BlockMoveTimer

@onready var GameOverMenu = $GameOverMenu
@onready var gameoversound = $GameOverSound

#TODO make ui graphics
@onready var Progbar = $ProgressBar

@onready var Scores = $Score
@onready var Lives = $BLives
@onready var Ammo = $Bullets
@onready var Diff = $DebugDiff
@onready var level = $DebugLVL


func _ready():
	origin = Ball.global_position
	randomize()
	Global.LoadGame()

func _process(delta):
#region UI updaters
	Progbar.value = Global.difficulty
	Progbar.max_value = Global.ProgbarCap
	Scores.text = str("Score: ", Global.scorepoints)
	if Global.selectedpowerup == Global.selectablepowerups.Gun:
		Ammo.text = str("Ammo: ", Global.Gunpower)
	if Global.selectedpowerup == Global.selectablepowerups.Ball:
		Ammo.text = str("Balls: ", Global.BallPower)
	if Global.selectedpowerup == Global.selectablepowerups.Parry:
		Ammo.text = str("Parry")
	Lives.text = str("Lives: ", Global.BonusLives)
	Diff.text = str("Diff.: ", Global.difficulty)
	level.text = str("Level: ", Global.level)
#endregion
	if WallTimer.time_left <= 0:
		Global.moving = true
		WallTimer.start()
		Count += 1
		Global.difficulty += 0.5
		if Progbar.value == Global.ProgbarCap:
			print("Next level!")
			Progbar.value = 0
			Global.ProgbarCap += Global.ProgbarCap/2
			print("current cap is: ", Global.ProgbarCap)
			Global.difficulty = 0
			Global.level += 1
			Fade.Start()
	else:
		Global.moving = false
	if Count == 4:
		print("new row...")
		print("difficulty: ", Global.difficulty)
		Global.difficultychancebonus += 1
		rowcontrol()

func _input(event):
	if Input.is_action_just_pressed("rotate_up") and Global.selectedpowerup == Global.selectablepowerups.Gun:
			Global.selectedpowerup = Global.selectablepowerups.Ball
	elif Input.is_action_just_pressed("rotate_up") and Global.selectedpowerup == Global.selectablepowerups.Ball:
			Global.selectedpowerup = Global.selectablepowerups.Parry
	elif Input.is_action_just_pressed("rotate_up") and Global.selectedpowerup == Global.selectablepowerups.Parry:
			Global.selectedpowerup = Global.selectablepowerups.Gun

	if Input.is_action_just_pressed("rotate_down") and Global.selectedpowerup == Global.selectablepowerups.Gun:
			Global.selectedpowerup = Global.selectablepowerups.Parry
	elif Input.is_action_just_pressed("rotate_down") and Global.selectedpowerup == Global.selectablepowerups.Parry:
			Global.selectedpowerup = Global.selectablepowerups.Ball
	elif Input.is_action_just_pressed("rotate_down") and Global.selectedpowerup == Global.selectablepowerups.Ball:
			Global.selectedpowerup = Global.selectablepowerups.Gun
	if Input.is_action_just_pressed("debugreset"):
		ResetBall()
		ResetMap()


	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = true
		$PauseMenu.show()

func ResetBall():
	Ball.position = origin
	Ball.velocity.y = 0
	Ball.velocity.x = 0
	BallFreeze.start()

func ResetMap():
	for block in get_tree().get_nodes_in_group("Blocks"):
		if is_instance_valid(block):
			block.queue_free()

func GameOverCheck():
	var ballcheck = get_tree().get_nodes_in_group("Ball")
	if ballcheck:
		print("are there balls?", ballcheck)
	elif Global.BonusLives <= 0:
		gameover()
	else:
		get_tree().reload_current_scene()

func gameover():
	gameoversound.playing = true
	get_tree().paused = true
	GameOverMenu.show()

func _on_killzone_area_entered(area):
	if Global.BonusLives <= 0:
		gameover()
	else:
		Global.BonusLives -= 1
		$Resettrans.Start()

func _on_killzone_body_entered(body):
	if body.is_in_group("Ball"):
		body.queue_free()
		await get_tree().process_frame
		GameOverCheck()
	#else:
		#if Global.BonusLives <= 0:
			#gameover()
		#else:
			#get_tree().reload_current_scene()
			#ResetBall()
			#ResetMap()
			#Global.BonusLives -= 1

func _on_lost_life_timer_timeout():
	Ball.velocity.y = Ball.BallSpeed

func _on_block_move_timer_timeout():
	if Global.difficulty >= Global.difficultytreshold:
		Global.difficultytreshold += Global.difficultytreshold
		if WallTimer.wait_time != 2:
			WallTimer.wait_time -= 1
			print("time is now: ", WallTimer.wait_time)

#hell
func rowcontrol():
	var diceroll = randi_range(1,10)
	print("rolled a ", diceroll)
	
#region Level 2 spawns
	if Global.level == 2:
		if diceroll >=5:
			var r = lvl2Row.instantiate()
			add_child(r)
			r.transform = $blocks/RowSpawner.global_transform
		elif diceroll == 10:
			var r = lvl2RowHard.instantiate()
			add_child(r)
			r.transform = $blocks/RowSpawner.global_transform
#endregion
#if all else fails
	else:
		print("spawning normal row")
		var r = spawnrow.instantiate()
		add_child(r)
		r.transform = $blocks/RowSpawner.global_transform
	Count = 0
