extends Sprite

var outcome 
var favor = 1
var luck = 0.4

var diceStatus = {
	"critical": false,
	"failure": false
}

func calculateOutcome():
	randomize()
	var randomValue = randf()
	var newOutcome
	if randomValue < luck:
		newOutcome = round(rand_range(11, 20))  
	else:
		newOutcome = round(rand_range(1, 20))

	outcome = newOutcome
	if outcome == 20:
		diceStatus["critical"] = true
	elif outcome == 1:
		diceStatus["failure"] = true
	else:
		diceStatus["critical"] = false
		diceStatus["failure"] = false
	return diceStatus

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "rolling":
		$AnimationPlayer.play(str(outcome))


	
