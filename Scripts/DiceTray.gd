extends Control

onready var outcomeLabel = $bg/outcome
onready var roll = $bg/roll
onready var rollWithAdvantage = $bg/advantageRoll
onready var D20 = $bg/D20
onready var secondD20 = $bg/secondD20
onready var dice1Animation = $bg/D20/AnimationPlayer
onready var dice2Animation = $bg/secondD20/AnimationPlayer

signal D20Result(outcome)
signal advantageD20Result(outcome)

var D20Outcome = null
var secondD20Outcome = null
var advantage = false

func canRoll():
	if advantage:
		rollWithAdvantage.disabled = false
		rollWithAdvantage.modulate = Color(1,1,1,1)
	else:
		rollWithAdvantage.disabled = true
		rollWithAdvantage.modulate = Color(1,1,1,.7)

func _ready():
	canRoll()
	outcomeLabel.text = ""
# warning-ignore:return_value_discarded
	Game.connect("d20Result",self,"onShowResult")
	roll.connect("pressed",self,"_on_roll_pressed")
	rollWithAdvantage.connect("pressed",self,"_on_roll_with_advantage_pressed")
# warning-ignore:return_value_discarded
	connect("D20Result",self,"onD20Result")
# warning-ignore:return_value_discarded
	connect("advantageD20Result",self,"onAdvantageD20Result")
	
func clear():
	outcomeLabel.hide()
	
	
func _on_roll_pressed():
	clear()
	dice1Animation.play("rolling")
	D20.calculateOutcome()
	var outcome = D20.outcome
	secondD20.hide()
	roll.disabled = true
	roll.modulate = Color(1,1,1,.7)
	yield(get_tree().create_timer(1.75), "timeout")
	roll.disabled = false
	roll.modulate = Color(1,1,1,1)
	emit_signal("D20Result",outcome)


func _on_roll_with_advantage_pressed():
	clear()
	secondD20.show()
	dice1Animation.play("rolling")
	dice2Animation.play("rolling")
	D20.calculateOutcome()
	secondD20.calculateOutcome()
	D20Outcome = D20.outcome  # Add this line
	secondD20Outcome = secondD20.outcome  # Add this line
	var outcome
	if D20Outcome > secondD20Outcome:
		outcome = D20Outcome
	elif secondD20Outcome > D20Outcome:
		outcome = secondD20Outcome
	else:
		outcome = secondD20Outcome
	rollWithAdvantage.disabled = true
	rollWithAdvantage.modulate = Color(1,1,1,.7)
	yield(get_tree().create_timer(1.75), "timeout")
	rollWithAdvantage.disabled = false
	rollWithAdvantage.modulate = Color(1,1,1,1)
	emit_signal("advantageD20Result",outcome)
	
func onAdvantageD20Result(outcome):
	outcomeLabel.show()
	if outcome != null:
		outcomeLabel.text = str(outcome)
		var dynamic_font = DynamicFont.new()
		if outcome >= 17:
			dynamic_font.size = 60
			dynamic_font.font_data = load("res://Assets/Fonts/Scaly Sans Caps.otf")
			outcomeLabel.set("custom_fonts/font", dynamic_font)
		else:
			dynamic_font.size = 40
			dynamic_font.font_data = load("res://Assets/Fonts/Scaly Sans Caps.otf")
			outcomeLabel.set("custom_fonts/font", dynamic_font)
	else:
		outcomeLabel.text = ""
	Game.D20outcome = outcome
	yield(get_tree().create_timer(2),"timeout")
	hide()
	
func onD20Result(outcome):
	outcomeLabel.show()
	if outcome != null:
		outcomeLabel.text = str(outcome)
		var dynamic_font = DynamicFont.new()
		if outcome >= 17:
			dynamic_font.size = 60
			dynamic_font.font_data = load("res://Assets/Fonts/Scaly Sans Caps.otf")
			outcomeLabel.set("custom_fonts/font", dynamic_font)
		else:
			dynamic_font.size = 40
			dynamic_font.font_data = load("res://Assets/Fonts/Scaly Sans Caps.otf")
			outcomeLabel.set("custom_fonts/font", dynamic_font)
	else:
		outcomeLabel.text = ""
	Game.D20outcome = outcome
	yield(get_tree().create_timer(2),"timeout")
	hide()

	
