extends KinematicBody2D
class_name playableCharacters

var startPos
var action = true
var bonusAction = false
var movement = false
var tween
var shiftSpeed = Game.shiftSpeed
var concentration
var currentCondition = CONDITIONS.NORMAL


enum CONDITIONS{
	NORMAL,
	STUNNED,
	BLINDED,
	PRONE,
	POISONED,
	PARALYZED,
	DEAFENED,
	INCAPACITATED,
	
}

func refreshRound():
	action = true
	bonusAction = true
	movement = true
	
func proneCondition():
	pass

func _ready():
	add_to_group("Characters")
	startPos = self.global_position
	tween = Tween.new()
	add_child(tween)
	match currentCondition:
		CONDITIONS.PRONE:
			proneCondition()

# warning-ignore:shadowed_variable
func move_to(destinatedPos):
	tween.interpolate_property(self, "position", self.position, destinatedPos, destinatedPos.distance_to(self.position) / shiftSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
