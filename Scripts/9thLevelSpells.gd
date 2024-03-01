extends Control

onready var spellCardPreload = preload("res://Scenes/spellCards/spellCard.tscn")
onready var spellCard = spellCardPreload.instance()
onready var pos = $position
onready var selectedCard = $selectedCard

onready var cardOriginalPos

func _ready():
	var i = 0
	for spell_name in JsonData.ninethLevelSpells.keys():
		spellCard = spellCardPreload.instance()
		var spell_info = JsonData.ninethLevelSpells[spell_name]
		spellCard.get_node("BG/name").text = str(spell_name)
		spellCard.get_node("BG/duration").text = str(spell_info["duration"])
		var components = str(spell_info["components"])
		var index = components.find("(")
		if index != -1:
			components = components.get_slice("(", 0).strip_edges()
			 
		spellCard.get_node("BG/components").text = components
		spellCard.get_node("BG/level").text = str(spell_info["level"])
		spellCard.get_node("BG/range").text = str(spell_info["range"])
		spellCard.get_node("BG/school").text = str(spell_info["school"])
		spellCard.get_node("BG/casingTime").text = str(spell_info["casting_time"])
		
		spellCard.rect_scale = Vector2(.4,.4)
		pos.add_child(spellCard)
		spellCard.set_name(spell_name)
		var name = spellCard.name
		spellCard.get_node("button").connect("mouse_entered",self,"onMouseEntered",[name,spellCard])
		spellCard.get_node("button").connect("mouse_exited",self,"onMouseExited",[name,spellCard])
		spellCard.get_node("button").connect("pressed",self,"onPressed",[name,spellCard])
		i += 1


func onPressed(name,spellCard):
	spellCard.rect_position = selectedCard.position

func onMouseEntered(name,spellCard):
	pass

func onMouseExited(name,spellCard):
	pass

#
