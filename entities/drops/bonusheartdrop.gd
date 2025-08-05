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
	Global.BonusLives += 1
	


func _on_pick_up_sound_finished():
	queue_free()
