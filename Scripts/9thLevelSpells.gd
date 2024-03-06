extends Control

onready var spellCardPreload = preload("res://Scenes/spellCards/spellCard.tscn")
onready var labelPreload = preload("res://Scenes/Utility Scenes/Label.tscn")
onready var spellCard = spellCardPreload.instance()

onready var pos = $bgPanel/node
onready var selectedCard = $selectedCard
onready var use = $bgPanel/use

onready var cardOriginalPos
var label

const cardPos = {}

onready var cards = []

func _ready():
#	OS.window_fullscreen = true
	use.connect("pressed",self,"onButtonPressed")
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
		
		spellCard.rect_position = pos.rect_position + Vector2(80 * (i), 0)
		spellCard.rect_scale = Vector2(.5,.5)
		cardOriginalPos = spellCard.rect_position
		cards.append(spellCard)
		pos.add_child(spellCard)
		spellCard.set_name(spell_name)
		var name = spellCard.name
		cardPos[name] = Vector2(cardOriginalPos)
		spellCard.get_node("button").connect("mouse_entered",self,"onMouseEntered",[name,spellCard])
		spellCard.get_node("button").connect("mouse_exited",self,"onMouseExited",[name,spellCard])
		spellCard.get_node("button").connect("pressed",self,"onPressed",[name,spellCard])
		i += 1
#	print(cardPos)
	label = labelPreload.instance()
	label.rect_position = get_global_mouse_position()
	add_child(label)
	label.hide()

func onButtonPressed():
	print("Casting Spell")

func onPressed(name, spellCard):
	if spellCard.rect_position == selectedCard.rect_global_position:
		# If the card is currently at the selected position, return it to the original position
		spellCard.rect_position = cardPos[name]
		spellCard.get_node("GlowBoarder").hide()
	else:
		# If the card is not at the selected position, move it to the selected position
		spellCard.rect_position = selectedCard.rect_global_position
		spellCard.get_node("GlowBoarder").show()



func onMouseEntered(name,spellCard):
	spellCard.rect_scale = Vector2(.6,.6)
	label.show()
	label.text = str(name)
	label.rect_position = get_local_mouse_position()
	

func onMouseExited(name,spellCard):
	spellCard.rect_scale = Vector2(.5,.5)
	label.hide()
#
