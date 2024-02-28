extends KinematicBody2D
class_name Zonshra

var destinatedPos = Vector2.ZERO
var startPos = Vector2.ZERO
var moveSpeed = Game.shiftSpeed
var canMove = false
var isMoving = false
var tween

func _ready():
	startPos = self.global_position
	tween = Tween.new()
	add_child(tween)

# warning-ignore:shadowed_variable
func move_to(destinatedPos):
	tween.interpolate_property(self, "position", self.position, destinatedPos, destinatedPos.distance_to(self.position) / moveSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
