extends Control

onready var buttonPreload = preload("res://Scenes/Utility Scenes/textureButton.tscn")
onready var whoToAttack = $bg/attackWho

var buttons = []
var number = null

func _ready():
	initializeButtons()
	Game.connect("buttonsChanged",self,"onButtonsChanged")
	
func initializeButtons():
	for i in range(len(Game.INITATIVE)):
		var button = buttonPreload.instance()
		button.set_name(str(Game.INITATIVE[i].name))
		button.get_node("name").text = str(Game.INITATIVE[i].name)
		buttons.append(button)
		$bg/Container.add_child(button)
		

func addButtons():
	if $bg/Container.get_child_count() > len(Game.attackableTargets):
		return
	else:
		for i in range(len(Game.attackableTargets)):
			var button = buttonPreload.instance()
			button.set_name(str(Game.attackableTargets[i]))
			button.get_node("name").text = str(Game.attackableTargets[i])
			$bg/Container.add_child(button)
	print("buttons :",$bg/Container.get_children())
		
	
func onButtonsChanged():
	var foundCharacters = []
	if buttons == []:
		initializeButtons()
#	print("buttons reinitialized: ",buttons," Attackable Targets: ",Game.attackableTargets)
	if Game.attackableTargets == []:
		print("it becomes null")
		for i in $bg/Container.get_children():
			i.disabled = true
			i.modulate = Color(.7,.7,.7,.7)
		return

	for j in range(len(Game.attackableTargets)):
		var find = buttons[j].name.find(Game.attackableTargets[j]) != 1
		if find:
			var name = Game.attackableTargets[j]
			var node = $bg/Container.get_node(str(name))
			foundCharacters.append(node)
			node.disabled = false
			node.modulate = Color(1,1,1,1)
			
	for k in $bg/Container.get_children():
		if not foundCharacters.has(k):
			k.disabled = true
			k.modulate = Color(.6,.6,.6,.6)

#	print("buttons :",$bg/Container.get_children())

func removeButtons():
	for i in $bg/Container.get_children():
		i.queue_free()
