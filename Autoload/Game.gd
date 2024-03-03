extends Node

var movePos = Vector2(0,0)
var gridPos 
var shiftSpeed = 1000
var occupiedSpace = []
var selectedCharacter = ""

# game mechanic vairables
var TURN = ""
var TURNINDEX = 0
var ROUNDS = 0
var INITATIVE = []
var TOTALINITIATIVE

# roll outcomes
var D20outcome

# global signals
# warning-ignore:unused_signal
signal d20Result(result)

# character variables


# methods
func calculateModifier(score: Array):
	if score.size() == 0:
		return 0
	else:
		return round((score[0] - 10)/2)
