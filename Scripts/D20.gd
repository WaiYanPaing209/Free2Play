extends Sprite

var outcome
var favor = 1
var luck = 0.5

func _ready():
	$roll.pressed = true


func calculateOutcome():
	randomize()
	var randomValue = randf()
	print(randomValue)
	if randomValue < luck:
		outcome = round(rand_range(11, 20))  
	else:
		outcome = round(rand_range(1, 20))

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "rolling":
		$AnimationPlayer.play(str(outcome))


func _on_roll_pressed():
	$AnimationPlayer.play("rolling")
	calculateOutcome()
