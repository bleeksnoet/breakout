extends CharacterBody2D

@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.y = speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity * delta)


func _on_bonuspoint_area_entered(area):
	$PickUpSound.playing = true
	Global.Gunpower += 3
	if Global.Gunpower >= Global.MaxGunpower:
		Global.Gunpower = Global.MaxGunpower
	



func _on_pick_up_sound_finished():
	queue_free()
