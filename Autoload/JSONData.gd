extends Node

var item_data: Dictionary
var cantripSpells = {}
var firstLevelSpells = {}
var secondLevelSpells = {}
var thirdLevelSpells = {}
var fourthLevelSpells = {}
var fifthLevelSpells = {}
var sixthLevelSpells = {}
var seventhLevelSpells = {}
var eighthLevelSpells = {}
var ninethLevelSpells = {}
onready var filepath = "res://db/spells.json"

# {
#Acid Splash:{
#casting_time:1 action, 
#components:V, S, 
#description:You hurl a bubble of acid. Choose one creature within range, or choose 
#two creatures within range that are within 5 feet of each other. A target must succeed 
#on a Dexterity saving throw or take 1d6 acid damage. This spell’s damage increases by 1d6 
#when you reach 5th level (2d6), 11th level (3d6), and 17th level (4d6)., 
#duration:Instantaneous, 
#level:0, 
#range:60 feet, 
#school:Conjuration
#}

func _ready():
	item_data = LoadData(filepath)
	for spell_name in item_data.keys():
		var spell_info = item_data[spell_name]
		if spell_info["level"] == 0:
			cantripSpells[spell_name] = spell_info
		elif spell_info["level"] == 1:
			firstLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 2:
			secondLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 3:
			thirdLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 4:
			fourthLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 5:
			fifthLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 6:
			sixthLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 7:
			seventhLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 8:
			eighthLevelSpells[spell_name] = spell_info
		elif spell_info["level"] == 9:
			ninethLevelSpells[spell_name] = spell_info
		
#	print("Cantrips: ",cantripSpells.keys().slice(0, 3))
#	print("First: ",firstLevelSpells.keys().slice(0, 3))
#	print("Second: ",secondLevelSpells.keys().slice(0, 3))
#	print("Third: ",thirdLevelSpells.keys().slice(0, 3))
#	print("Fourth: ",fourthLevelSpells.keys().slice(0, 3))
#	print("Fifth: ",fifthLevelSpells.keys().slice(0, 3))
#	print("Sixth: ",sixthLevelSpells.keys().slice(0, 3))
#	print("Seventh: ",seventhLevelSpells.keys().slice(0, 3))
#	print("Eighth: ",eighthLevelSpells.keys().slice(0, 3))
#	print("Nineth: ",ninethLevelSpells.keys().slice(0, 3))
		

func LoadData(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
