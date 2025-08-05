extends CanvasLayer

@export_file("*.tscn") var Target

func Start():
	Transition(Target)

func Transition(Target):
	$AnimationPlayer.play("Dissolve")
	await($AnimationPlayer.animation_finished)
	get_tree().change_scene_to_file(Target)
	$AnimationPlayer.play_backwards("Dissolve")
