extends CharacterBody2D

var speed = -800

func _physics_process(delta):
	position += transform.y * speed * delta

func _on_area_2d_body_entered(body):
	queue_free()
