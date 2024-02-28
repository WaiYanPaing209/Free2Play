extends Control

onready var outcomeLabel = $bg/outcome
onready var roll = $bg/roll
onready var D20 = $bg/D20
onready var secondD20 = $bg/secondD20
onready var dice1Animation = $bg/D20/AnimationPlayer
onready var dice2Animation = $bg/secondD20/AnimationPlayer

func _ready():
	outcomeLabel.text = ""
# warning-ignore:return_value_discarded
	Game.connect("d20Result",self,"onShowResult")
	roll.connect("pressed",self,"_on_roll_pressed")
	
func onShowResult(outcome):
	outcome = D20.outcome
	if outcome != null:
		outcomeLabel.text = str(D20.outcome)
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


func _on_roll_pressed():
	dice1Animation.play("rolling")
	D20.calculateOutcome()
