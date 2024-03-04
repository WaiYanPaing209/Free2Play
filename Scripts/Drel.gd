extends nonPlayableCharacters
class_name Drel

var stats = {
	"STR" : [10],
	"DEX" : [18],
	"CON" : [],
	"WIS" : [],
	"CHA" : []
}

var destinatedPos = Vector2.ZERO
var initiative
var speed = 30
var armorClass = 11
var canMove = false
var isMoving = false
var attackRange = 5
var toHit = 7

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
