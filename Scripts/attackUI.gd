extends Control

onready var buttonPreload = preload("res://Scenes/Utility Scenes/button.tscn")

var number = null

func addButtons():
	$bg/Container.columns = 3
	if number == null:
		return
	else:
		for i in number:
			var button = buttonPreload.instance()
			button.get_node("RedDot").hide()
			button.get_node("countLabel").hide()
			$bg/Container.add_child(button)
# Called when the node enters the scene tree for the first time.

func removeButtons():
	for i in $bg/Container.get_children():
		i.queue_free()
