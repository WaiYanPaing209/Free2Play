extends Control

onready var buttonPreload = preload("res://Scenes/Utility Scenes/textureButton.tscn")
onready var whoToAttack = $bg/attackWho

var number = null

func addButtons():
	# Check if buttons are already added
	print(Game.attackableTargets)
	removeButtons()
	# First, remove buttons that are not in attackableTargets
	for j in $bg/Container.get_children():
		if Game.attackableTargets.find(j.name) == -1:
			j.queue_free()

	# Then, add new buttons
	for i in range(len(Game.attackableTargets)):
		var button = buttonPreload.instance()
		button.set_name(str(Game.attackableTargets[i]))
		button.get_node("name").text = str(Game.attackableTargets[i])
		$bg/Container.add_child(button)
		
# Called when the node enters the scene tree for the first time.

func removeButtons():
	for i in $bg/Container.get_children():
		i.queue_free()
