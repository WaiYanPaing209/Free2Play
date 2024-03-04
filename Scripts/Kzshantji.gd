extends nonPlayableCharacters
class_name Kzshantji

var stats = {
	"STR" : [10],
	"DEX" : [19],
	"CON" : [],
	"WIS" : [],
	"CHA" : []
}

var hitDie
var hitPoint 
var destinatedPos = Vector2.ZERO
var initiative
var speed = 30
var armorClass = 19
var canMove = false
var isMoving = false
var attackRange = 60
var toHit = 10

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
