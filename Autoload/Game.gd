extends Node

var movePos = Vector2(0,0)
var gridPos 
var shiftSpeed = 1000
var occupiedSpace = []
var selectedCharacter = ""

# game mechanic vairables
var TURN = ""
var TURNINDEX = 0
var ROUNDS
var INITATIVE = []
var TOTALINITIATIVE

# global signals
# warning-ignore:unused_signal
signal d20Result(result)

# character variables


# methods
func calculateModifier(score):
	return round((score - 10)/2)
