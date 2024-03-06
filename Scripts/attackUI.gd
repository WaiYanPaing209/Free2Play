extends Control

onready var buttonPreload = preload("res://Scenes/Utility Scenes/textureButton.tscn")
onready var whoToAttack = $bg/attackWho

var buttons = []
var number = null

func _ready():
	initializeButtons()
	Game.connect("buttonsChanged",self,"addButtons")
	
func initializeButtons():
	for i in range(len(Game.INITATIVE)):
		var button = buttonPreload.instance()
		button.set_name(str(Game.INITATIVE[i].name))
		button.get_node("name").text = str(Game.INITATIVE[i].name)
		buttons.append(button)
		

func addButtons():
	if $bg/Container.get_child_count() > len(Game.attackableTargets):
		return
	else:
		for i in range(len(Game.attackableTargets)):
			var button = buttonPreload.instance()
			button.set_name(str(Game.attackableTargets[i]))
			button.get_node("name").text = str(Game.attackableTargets[i])
			$bg/Container.add_child(button)
		
func refreshButtons():
	removeButtons()
	if buttons == []:
		initializeButtons()
	print("buttons reinitialized: ",buttons," Attackable Targets: ",Game.attackableTargets)
	if Game.attackableTargets == []:
		print("it becomes null")
		return
	else:
		for j in range(len(Game.attackableTargets)):
			var find = buttons[j].name.find(Game.attackableTargets[j]) != 1
			if find:
				var name = Game.attackableTargets[j]
				for button in buttons:
					if button.name == name:
						$bg/Container.add_child(button)
				
#	print(buttons)
# Called when the node enters the scene tree for the first time.

func removeButtons():
	for i in $bg/Container.get_children():
		i.queue_free()
