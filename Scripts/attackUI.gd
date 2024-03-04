extends Control

onready var buttonPreload = preload("res://Scenes/Utility Scenes/textureButton.tscn")
onready var whoToAttack = $bg/attackWho

var number = null

func addButtons():
	$bg/Container.columns = 3
	if number == null:
		return
	else:
		for i in number:
			var button = buttonPreload.instance()
			$bg/Container.add_child(button)
# Called when the node enters the scene tree for the first time.

func removeButtons():
	for i in $bg/Container.get_children():
		i.queue_free()
