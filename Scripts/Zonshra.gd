extends nonPlayableCharacters
class_name Zonshra

var stats = {
	"STR" : [10],
	"DEX" : [22],
	"CON" : [15],
	"WIS" : [14],
	"CHA" : [12]
}

var hitPoint = 220
var destinatedPos = Vector2.ZERO
var speed = 35
var armorClass = 21
var initiative
var canMove = false
var isMoving = false
var attackRange = 15
var toHit = 11

var gridIndex : int = -1

func assignModifiers():
	for i in stats.keys():
		var score = stats[i]
		if score.size() == 0:
			break
		else:
			var mod = Game.calculateModifier(score)
			score.append(mod)
			


func _ready():
	assignModifiers()
