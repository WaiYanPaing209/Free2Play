extends Control

onready var spellCardPreload = preload("res://Scenes/spellCards/spellCard.tscn")

func _ready():
	var i = 0
	for spell_name in JsonData.ninethLevelSpells.keys():
		var spellCard = spellCardPreload.instance()
		var spell_info = JsonData.ninethLevelSpells[spell_name]
		spellCard.get_node("texture/description").text = str(spell_info["description"])
		spellCard.get_node("texture/duration").text = str(spell_info["duration"])
		spellCard.get_node("texture/name").text = str(spell_name)
		
		spellCard.rect_position = $position.position + Vector2(280 * (i), 0)
		spellCard.rect_scale = Vector2(.8,.8)
		$position.add_child(spellCard)
		var name = spellCard.name
		spellCard.connect("mouse_entered",self,"onMouseEntered",[name,spell_name])
		spellCard.connect("mouse_exited",self,"onMouseExited")
		i += 1


func onMouseEntered(name,spellName):
	for i in $position.get_children():
		if i is Control and i.name == name:
			i.rect_scale = Vector2(1.5,1.5)
			i.get_node("texture/description").clip_text = false
			i.raise()
	
func onMouseExited():
	for i in $position.get_children():
		if i is Control:
			i.rect_scale = Vector2(.8,.8)
			i.get_node("texture/description").clip_text = true
