extends Node

var movePos = Vector2(0,0)
var gridPos 
var shiftSpeed = 1000
var occupiedSpace = []
var attackableTargets = []
var wholeGrid = {}
var selectedCharacter = ""

# game mechanic vairables
var TURN = ""
var TURNINDEX = 0
var ROUNDS = 0
var INITATIVE = []
var TOTALINITIATIVE

# UI singletons
var RED = "#4ee22727"
var GREEN = "#9d13582b"
var NORMAL = "#4e160c0c"
var buttons = []

# roll outcomes
var D20outcome

# global signals
# warning-ignore:unused_signal
signal d20Result(result)
# warning-ignore:unused_signal
signal compareOutcomes(first,second)
signal buttonsChanged

# character variables
var first
var second

# methods
func calculateModifier(score: Array):
	if score.size() == 0:
		return 0
	else:
		return round((score[0] - 10)/2)
