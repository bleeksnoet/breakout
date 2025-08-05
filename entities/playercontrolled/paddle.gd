extends CharacterBody2D

var direction = Vector2.ZERO
var BASESPEED = 500
var SPEED = 500
var DASHSPEED = 2000
var Parrying = false

@onready var DashTimer = $DashTimer
@onready var bullets = preload("res://entities/other/bullettest.tscn")
@onready var bonusball = preload("res://entities/playercontrolled/ball.tscn")
@onready var ShootNoise = $ShootNoise

func _physics_process(delta):
	direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	dash()
	shooting()
	move_and_slide()


#func _on_area_2d_body_entered(body):
	#print(Parrying)
	#if body.is_in_group("Ball") and Parrying == false:
		#Global.combo = false
		#Global.parried = false
	#if Parrying == true:
		#Global.parried = true

func dash():
	if direction and Input.is_action_just_pressed("Dash"):
		SPEED = DASHSPEED
		DashTimer.start()

func shooting():
	if Input.is_action_just_pressed("Action") and Global.selectedpowerup == Global.selectablepowerups.Gun:
		gunattack()
		
	elif Input.is_action_just_pressed("Action") and Global.selectedpowerup == Global.selectablepowerups.Ball:
		ballspawn()
		
	elif Input.is_action_just_pressed("Action") and Global.selectedpowerup == Global.selectablepowerups.Parry:
		Parry()
		
func ballspawn():
	if Global.BallPower >= 1:
		var b = bonusball.instantiate()
		var b2 = bonusball.instantiate()
		b.bonusball = true
		b2.bonusball = true
		owner.add_child(b)
		owner.add_child(b2)
		b.transform = $Barrel1.global_transform
		b2.transform = $Barrel2.global_transform
		Global.BallPower -= 1

func gunattack():
	if Global.Gunpower >= 1:
		ShootNoise.playing = true
		var b = bullets.instantiate()
		var b2 = bullets.instantiate()
		owner.add_child(b)
		owner.add_child(b2)
		b.transform = $Barrel1.global_transform
		b2.transform = $Barrel2.global_transform
		Global.Gunpower -= 1

func Parry():
	$AnimationPlayer.play("Parry")
	print("parrying on")
	Parrying = true

func _on_dash_timer_timeout() -> void:
	SPEED = BASESPEED

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Parrying = false
	print("parrying off")
