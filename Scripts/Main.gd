extends Node

onready var gridPreload = preload("res://Scenes/Utility Scenes/1.tscn")
onready var selectedUi = preload("res://Assets/Images/SelectedUI.png")
onready var labelPreload = preload("res://Scenes/Utility Scenes/Label.tscn")
onready var bodylabelPreload = preload("res://Scenes/Utility Scenes/booksanityLabel.tscn")

onready var GRID = $Grid
onready var gridRangeLabel = $UI/mainUI_BG/range
onready var debug = $UI/mainUI_BG/debug
onready var controlPanel = $UI/controlPanel
onready var moveButton = $UI/controlPanel/Move
onready var attackButton = $UI/controlPanel/Attack
onready var undoButton = $UI/controlPanel/Undo
onready var okButton = $UI/controlPanel/Done
onready var sides = $UI/mainUI_BG/sides
onready var turn = $UI/mainUI_BG/Turn
onready var rounds = $UI/mainUI_BG/Rounds
onready var nameLabels = $UI/nameLabels
onready var attackUI = $UI/attackUI
onready var diceTray = $UI/DiceTray
onready var initiateGrid = $UI/mainUI_BG/InitiativeGrid
onready var UI = $UI
onready var bodylabel = $UI/mainUI_BG/rollLog/booksanityLabel

signal detectChanges
signal nextTurn

var characters = []
var overlappingBodies = []
var moveableGrid = []
var attackGrid = []
var gridDifference = []
var attackableTargets = []
var gridSceneInstance = null
var gridRange = 5
var columns
var rows
var area
var width = 0
var height = 0
var selected = false
var selectedGrid = null
var is_pressed = false
var isMoveable
var isAttackable
var speedDefault = 30
var spawned = false
var character

# characters
var selectedUI = Sprite.new()
var controlUI = Sprite.new()

func clearGrid():
	for child in GRID.get_children():
		if child is TextureButton:
			child.modulate = Color("#4e160c0c")
			
func array_difference(array1: Array, array2: Array) -> Array:
	var difference = []
	if len(array1) >= len(array2):
		for element in array1:
			if not (element in array2):
				difference.append(element)
	else:
		for element in array2:
			if not (element in array1):
				difference.append(element)
	return difference

# warning-ignore:shadowed_variable
func modulateGrids(moveableGrid: Array, excludeGridName: String = "", gridType: String = ""):
	for child in GRID.get_children():
		if child is TextureButton:
			match gridType:
				"move":
					var gridNum = int(child.get_name()) + 1
					if moveableGrid.find(gridNum) != -1:
						if child.name != excludeGridName:
							child.modulate = Color("#9d13582b")  # Modulate color for accessible grids
					else:
						child.modulate = Color("#4e160c0c")  # Modulate color for non-accessible grids
				"attack":
					var gridNum = int(child.get_name()) + 1
					if moveableGrid.find(gridNum) != -1:
						child.modulate = Color("#4ee22727")
						

# warning-ignore:shadowed_variable
# warning-ignore:unused_argument
# warning-ignore:shadowed_variable
func onPressed(grid, gridName):
	is_pressed = true
	Game.movePos = grid.rect_position
	Game.gridPos = int(gridName) + 1
	emit_signal("detectChanges")

	var zone = grid.get_node("detectionZone")
	overlappingBodies = zone.get_overlapping_bodies()
	if overlappingBodies.size() > 0:
		Game.selectedCharacter = overlappingBodies[0].name
		spawned = false
		if Game.selectedCharacter == Game.TURN:
#			print(Game.selectedCharacter)
			debug.text = Game.TURN + " Selected" if name != null else ""
			character = characters[Game.TURNINDEX]
			character.z_index = 2
			moveableGrid = find_accessible_range(int(Game.gridPos), character.speed, Game.occupiedSpace)
			attackGrid = find_accessible_range(int(Game.gridPos),character.attackRange,[])
			gridDifference = array_difference(moveableGrid,attackGrid)
			modulateGrids(gridDifference,"","move")
			modulateGrids(attackGrid,"","attack")
			searchAttackRange()
			selectedGrid = grid
			isMoveable = moveableGrid.find(Game.gridPos) != -1
			refreshChanges()
			controlPanel.show()
		else:
			debug.text = "Not the turn of " + Game.selectedCharacter
			clearGrid()

	if is_pressed and not spawned and Game.selectedCharacter == Game.TURN:
		spawned = true
		grid.modulate = Color("#db0051a7")
	else:
		for i in characters.size():
			if gridName != characters[i].name:
				break
		if not isMoveable:
			grid.modulate = Color("#db0051a7")
			modulateGrids(moveableGrid, gridName,"move")

func movePressed():
	isMoveable = moveableGrid.find(Game.gridPos) != -1
	if isMoveable:
#		controlPanel.hide()
		for character in characters:
			if Game.selectedCharacter == character.name and Game.selectedCharacter == Game.TURN:
				match character.movement:
					true:
						character.startPos = character.position
						character.move_to(Game.movePos + Vector2(20, 20)) # character offset
						nameLabels.get_node(str(character.name)).hide()
						yield(get_tree().create_timer(.5),"timeout")
						character.z_index = 0
						nameLabels.get_node(str(character.name)).rect_position = Game.movePos + Vector2(40, 30)# label offset
						nameLabels.get_node(str(character.name)).show() 
						clearGrid()
						character.movement = false
					false:
						debug.text = "No Movement Available"
				
	else:
		debug.text = "Invalid Move!"
	emit_signal("detectChanges")
#	refreshChanges()
	
func checkActions():
# warning-ignore:shadowed_variable
	for character in characters:
		if character.movement == false and character.action == false and character.bonusAction == false:
			yield(get_tree().create_timer(.5),"timeout")
			emit_signal("nextTurn")
	
func undoPressed():
# warning-ignore:shadowed_variable
	for character in characters:
		if Game.selectedCharacter == character.name and Game.selectedCharacter == Game.TURN:
			character.bonusAction = false
	refreshChanges()
	emit_signal("detectChanges")

# warning-ignore:shadowed_variable
func onMouseEntered(grid):
	selectedUI.position = grid.rect_position + Vector2(20,20)
	selectedUI.show()

# warning-ignore:shadowed_variable
# warning-ignore:unused_argument
func onMouseExited(grid):
	selectedUI.hide()
	
func _ready():
	columns = GRID.columns
	rows = columns
	width = gridRange * columns
	height = gridRange * rows
	area = rows * columns
	gridRangeLabel.text = "Range: " + str(width) + " x " + str(height)
	sides.text = "Grid: " + str(rows) + " x " + str(columns)
	debug.text = ""
	
	for i in range(0,int(area)):
		var gridInstance = gridPreload.instance()
		gridSceneInstance = gridInstance
		gridInstance.set_name(str(i))
		GRID.add_child(gridInstance)
		gridInstance.connect("pressed",self,"onPressed",[gridInstance,gridInstance.name])
		gridInstance.connect("mouse_entered",self,"onMouseEntered",[gridInstance])
		gridInstance.connect("mouse_exited",self,"onMouseExited",[gridInstance])
		
	rollForInitiative()
	
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	undoButton.connect("pressed",self,"undoPressed")
	moveButton.connect("pressed", self, "movePressed")
	attackButton.connect("pressed",self,"onAttackPressed")
	okButton.connect("pressed",self,"onDonePressed")
	connect("detectChanges",self,"detectChanges")
	connect("nextTurn",self,"onNextTurn")
		
	selectedUI.texture = selectedUi
	selectedUI.scale = Vector2(1.25,1.25)
	GRID.add_child(selectedUI)
	selectedUI.hide()
	yield(get_tree(), "idle_frame")
	findOccupiedSpace()
	initializeGame()
	
func onAttackPressed():
	isAttackable = attackGrid.find(Game.gridPos) != 1
	if isAttackable:
		for character in characters:
			if Game.selectedCharacter == character.name and Game.selectedCharacter == Game.TURN:
				character.action = false
		refreshChanges()
		attackableTargets.clear()
		attackUI.removeButtons()
		emit_signal("detectChanges")

func onDonePressed():
	emit_signal("nextTurn")
	
func rollForInitiative():
	randomize()
	for j in GRID.get_children():
		if j.is_in_group("Characters"):
			characters.append(j)
	bodylabel.text = ""
	for character in characters:
		var roll = int(round(rand_range(1,20)))
		character.initiative = roll + character.stats["DEX"][1]
		bodylabel.text += str(character.name) + " rolled : " + str(roll) + " (+" + str(Game.calculateModifier(character.stats["DEX"])) + ") Total: " + str(character.initiative) + " !\n"
	characters.sort_custom(self, "_compareInitiative")


func _compareInitiative(a, b):
	if a.initiative == b.initiative:
		return a.stats["DEX"] > b.stats["DEX"]
	else:
		return a.initiative > b.initiative


func onNextTurn():
	attackableTargets.clear()
	attackUI.removeButtons()
	if Game.TURNINDEX < Game.TOTALINITIATIVE:
		Game.TURNINDEX += 1
		Game.TURN = Game.INITATIVE[Game.TURNINDEX].name
		Game.INITATIVE[int(Game.TURNINDEX) - 1].refreshRound()
	else:
		Game.TURNINDEX = 0
		Game.TURN = Game.INITATIVE[Game.TURNINDEX].name
		Game.ROUNDS += 1
	refreshChanges()
	clearGrid()
		

func refreshChanges():
	turn.text = str(Game.TURN) + "'s Turn"
#	debug.text = ""
	rounds.text = "Rounds : " + str(Game.ROUNDS)
	controlPanel.get_node("Turn").text = str(Game.TURN) + " 's Control Panel"
	controlPanel.get_node("Action").text = "Action : " + str(int(Game.INITATIVE[int(Game.TURNINDEX)].action))
	controlPanel.get_node("bonusAction").text = "Bonus Action : " + str(int(Game.INITATIVE[int(Game.TURNINDEX)].bonusAction))
	controlPanel.get_node("movement").text = "Movement : " + str(int(Game.INITATIVE[int(Game.TURNINDEX)].movement))
	controlPanel.get_node("Move").get_node("countLabel").text = str(int(Game.INITATIVE[int(Game.TURNINDEX)].movement))
	controlPanel.get_node("Attack").get_node("countLabel").text = str(int(Game.INITATIVE[int(Game.TURNINDEX)].action))
	
	for i in range(initiateGrid.get_child_count()):
		var label = initiateGrid.get_child(i)
		if label.text == Game.TURN:
			label.add_color_override("font_color", Color(1, 0, 0, 1))  # Change font color to red
		else:
			label.add_color_override("font_color", Color(1, 1, 1, 1)) 
			label.rect_scale = Vector2(1,1)

func find_accessible_range(selected_number: int, movementRange: int, ignore_numbers: Array) -> Array:
	var accessible_numbers: Array = []
# warning-ignore:integer_division
	var row = (selected_number - 1) / rows + 1
	var col = (selected_number - 1) % columns + 1
	# Calculate row and column limits
	var row_lower_limit = max(1, row - movementRange/gridRange)
	var row_upper_limit = min(rows, row + movementRange/gridRange)
	var col_lower_limit = max(1, col - movementRange/gridRange)
	var col_upper_limit = min(columns, col + movementRange/gridRange)
	# Add accessible numbers within the limits
	for r in range(row_lower_limit, row_upper_limit + 1):
		for c in range(col_lower_limit, col_upper_limit + 1):
			var num = (r - 1) * rows + c
			if num != selected_number and not ignore_numbers.has(num):
				accessible_numbers.append(num)
	return accessible_numbers
	
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func searchAttackRange():
#	print(attackGrid)
	var index = attackGrid.size()
	for i in range(index):
		var grid = attackGrid[i]
		var node = GRID.get_node(str(grid - 1)).get_node("detectionZone")  # Adjust the index here
		overlappingBodies = node.get_overlapping_bodies()
		if overlappingBodies.size() > 0:
			for ii in overlappingBodies:
				attackableTargets.append(ii.name)
	attackUI.number = attackableTargets.size()
	attackUI.addButtons()
	var buttonIndex = 0
	for k in attackUI.get_node("bg/Container").get_children():
		if k is Button:
			if buttonIndex < attackableTargets.size():
				k.set_name(str(attackableTargets[buttonIndex]))
			if k.is_connected("pressed",self,"onUIAttackPressed"):
				k.disconnect("pressed",self,"onUIAttackPressed")
			k.connect("pressed",self,"onUIAttackPressed",[k.name])
			if buttonIndex < attackableTargets.size():
				k.text = attackableTargets[buttonIndex]
				buttonIndex += 1
	attackUI.show()
	print(attackableTargets)

func onUIAttackPressed(name):
	attackableTargets.clear()
	attackUI.removeButtons()
	diceTray.show()
	
func findOccupiedSpace():
	Game.occupiedSpace.clear()
	for child in GRID.get_children():
		if child is TextureButton:
			var zone = child.get_node("detectionZone")
			overlappingBodies = zone.get_overlapping_bodies()
			if overlappingBodies.size() > 0:
				for i in overlappingBodies:
					var pos = int(child.get_name()) + 1
					Game.occupiedSpace.append(pos)

func detectChanges():
	findOccupiedSpace()
	checkActions()
	
func nextTurn():
	var current_index = Game.INITATIVE.find(Game.TURN)
	attackableTargets.clear()
	attackUI.removeButtons()
	if current_index == Game.INITATIVE.size() - 1:
		Game.TURN = Game.INITATIVE[0].name
		rounds.text = str(int(rounds.text) + 1)
	else:
		Game.TURN = Game.INITATIVE[current_index + 1].name
	turn.text = str(Game.TURN) + "'s Turn"
	for i in range(initiateGrid.get_child_count()):
		var label = initiateGrid.get_child(i)
		if label.text == Game.TURN:
			label.add_color_override("font_color", Color(1, 0, 0, 1))  # Change font color to red
		else:
			label.add_color_override("font_color", Color(0, 0, 0, 0))  # Change font color to black

func initializeGame():
	controlPanel.hide()
	Game.ROUNDS += 1
	Game.INITATIVE = characters
	Game.TURN = characters[Game.TURNINDEX].name
	Game.TOTALINITIATIVE = Game.INITATIVE.size() - 1 # to match with array index
	turn.text = str(Game.TURN) + "'s Turn"
	rounds.text = "Rounds : " + str(Game.ROUNDS)
	
	for i in Game.INITATIVE.size():
		var label = labelPreload.instance()
		var name = Game.INITATIVE[i].name
		label.text = str(name)
		if name == Game.TURN:
			label.add_color_override("font_color", Color(1, 0, 0, 1))
		initiateGrid.add_child(label)
		
	for j in GRID.get_children():
		if j.is_in_group("Characters"):
			var label = labelPreload.instance()
			label.text = str(j.name)
			label.set_name(j.name)
			label.rect_position = j.global_position + Vector2(-20,-35)
			nameLabels.add_child(label)
		
	
	
#	print(Game.TURN)

