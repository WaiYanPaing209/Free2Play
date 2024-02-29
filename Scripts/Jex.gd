extends KinematicBody2D
class_name Jex

var stats = {
	"STR" : 10,
	"DEX" : 10,
}

var destinatedPos = Vector2.ZERO
var startPos = Vector2.ZERO
var shiftSpeed = Game.shiftSpeed
var initiative
var speed = 30
var canMove = false
var isMoving = false
var tween

func _ready():
	add_to_group("Characters")
	startPos = self.global_position
	tween = Tween.new()
	add_child(tween)

# warning-ignore:shadowed_variable
func move_to(destinatedPos):
	tween.interpolate_property(self, "position", self.position, destinatedPos, destinatedPos.distance_to(self.position) / shiftSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

