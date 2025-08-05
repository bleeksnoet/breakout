extends CharacterBody2D

var BallSpeed = -700
var collisiondata
var CurrentParryMult = 1
var MaxParryMult = 3
var ParryStep = 0.5
var bonusball = false
@onready var hitsound = $hitsound


func _ready():
	if bonusball:
		$HoloEffect.show()
		$HoloBall.show()
		$BaseBall.hide()
	UpdateVelocity()

func _physics_process(delta):
	UpdateVelocity()
	
	collisiondata = move_and_collide(velocity * delta)
	if collisiondata:
		velocity.x += randf_range(-20,20)
		velocity = velocity.bounce(collisiondata.get_normal())

func UpdateVelocity():
	var BaseDir = velocity.normalized()
	
	if BaseDir == Vector2.ZERO:
		BaseDir = Vector2(randf_range(-1, 1), -1).normalized()
		
	velocity = BaseDir * abs(BallSpeed) * CurrentParryMult


func _on_area_2d_area_entered(area):
	var pitchscale = randi_range(1, 2)
	hitsound.pitch_scale = pitchscale
	hitsound.playing = true


func _on_area_2d_body_entered(body):
	var pitchscale = randi_range(1, 2)
	hitsound.pitch_scale = pitchscale
	hitsound.playing = true
	if body.is_in_group("Paddle") and body.Parrying == true:
		CurrentParryMult = min(CurrentParryMult + ParryStep, MaxParryMult)
		print(CurrentParryMult)
		Global.scorepoints += CurrentParryMult
		$ParryNoise.play()
	elif body.is_in_group("Paddle") and body.Parrying == false:
		CurrentParryMult = 1.0
		print(CurrentParryMult)
		
