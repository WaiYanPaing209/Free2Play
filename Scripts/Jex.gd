extends nonPlayableCharacters
class_name Jex

var stats = {
	"STR" : [10],
	"DEX" : [10],
	"CON" : [],
	"WIS" : [],
	"CHA" : []
}

var destinatedPos = Vector2.ZERO
var hitPoint = 100
var initiative
var speed = 30
var armorClass = 15
var canMove = false
var isMoving = false
var attackRange = 5
var toHit = 8

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

