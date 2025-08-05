extends CharacterBody2D

var BallSpeed = 700
var collisiondata
@onready var hitsound = $hitsound


func _ready():
	velocity.y = BallSpeed
	velocity.x += randf_range(-20,20)

func _physics_process(delta):
	collisiondata = move_and_collide(velocity * delta)
	if collisiondata:
		velocity.x += randf_range(-20,20)
		velocity = velocity.bounce(collisiondata.get_normal())

func _on_area_2d_area_entered(area):
	var pitchscale = randi_range(1, 2)
	hitsound.pitch_scale = pitchscale
	hitsound.playing = true

func _on_area_2d_body_entered(body):
	var pitchscale = randi_range(1, 2)
	hitsound.pitch_scale = pitchscale
	hitsound.playing = true
