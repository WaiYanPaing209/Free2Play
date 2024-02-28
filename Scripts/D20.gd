extends Sprite

var outcome
var favor = 1
var luck = 0.4
var previousOutcomes = []

func calculateOutcome():
	randomize()
	var randomValue = randf()
	var newOutcome
	if randomValue < luck:
		newOutcome = round(rand_range(11, 20))  
	else:
		newOutcome = round(rand_range(1, 20))
	
	while newOutcome in previousOutcomes:
		newOutcome = round(rand_range(1, 20))
	
	previousOutcomes.append(newOutcome)
	outcome = newOutcome

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "rolling":
		$AnimationPlayer.play(str(outcome))
		Game.emit_signal("d20Result",outcome)


	
