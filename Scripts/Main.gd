extends Node2D

onready var gridPreload = preload("res://Scenes/Utility Scenes/1.tscn")
onready var selectedUi = preload("res://Assets/Images/SelectedUI.png")
onready var labelPreload = preload("res://Scenes/Utility Scenes/Label.tscn")

onready var GRID = $Grid
onready var gridRangeLabel = $UI/mainUI_BG/range
onready var debug = $UI/mainUI_BG/debug
onready var moveButton = $UI/mainUI_BG/Move
onready var undoButton = $UI/mainUI_BG/Undo
onready var sides = $UI/mainUI_BG/sides
onready var turn = $UI/mainUI_BG/Turn
onready var rounds = $UI/mainUI_BG/Rounds
onready var initiateGrid = $UI/mainUI_BG/InitiativeGrid

signal detectChanges

var characters = []
var overlappingBodies = []
var moveableGrid = []
var gridRange = 5
var columns
var rows
var area
var width = 0
var height = 0
var selected = false
var selectedGrids = 0
var maxGrids = 6 # default
var is_pressed = false
var speedDefault = 30
var spawned = false

# characters 

var selectedUI = Sprite.new()
var controlUI = Sprite.new()

func clearGrid():
	for child in $Grid.get_children():
		if child is TextureButton:
			child.modulate = Color("#4e160c0c")

# warning-ignore:shadowed_variable
func modulateGrids(moveableGrid: Array):
	for child in $Grid.get_children():
				if child is TextureButton:
					var gridNum = int(child.get_name()) + 1
					if moveableGrid.find(gridNum) != -1:
						child.modulate = Color("#9d13582b")  # Modulate color for accessible grids
					else:
						child.modulate = Color("#4e160c0c")  # Modulate color for non-accessible grids


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
		debug.text = Game.selectedCharacter + " Selected" if name != null else ""
		for character in characters:
			var chrName = character.name
			if Game.selectedCharacter == chrName:
				character.z_index = 2
				moveableGrid = find_accessible_range(int(Game.gridPos), 30, Game.occupiedSpace)
				modulateGrids(moveableGrid)
			else:
				character.z_index = 0
	else:
		debug.text = ""

	if is_pressed and not spawned:
		spawned = true
		grid.modulate = Color("#db0051a7")
	else:
		grid.modulate = Color("#db0051a7")

func movePressed():
	var isMoveable = moveableGrid.find(Game.gridPos) != -1
	if isMoveable:
		for character in characters:
			if Game.selectedCharacter == character.name:
				character.startPos = character.position
				character.move_to(Game.movePos + Vector2(20, 20))
				clearGrid()
	else:
		print("Invaild Move!")
		debug.text = "Invalid Move!"
	emit_signal("detectChanges")
	
	
func undoPressed():
	pass

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
		gridInstance.set_name(str(i))
		GRID.add_child(gridInstance)
		gridInstance.connect("pressed",self,"onPressed",[gridInstance,gridInstance.name])
		gridInstance.connect("mouse_entered",self,"onMouseEntered",[gridInstance])
		gridInstance.connect("mouse_exited",self,"onMouseExited",[gridInstance])
		
	for j in GRID.get_children():
		if j is KinematicBody2D:
			characters.append(j)

	print("Characters Initiated: ",characters)

# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	undoButton.connect("pressed",self,"undoPressed")
	moveButton.connect("pressed", self, "movePressed")
	connect("detectChanges",self,"detectChanges")
		
	selectedUI.texture = selectedUi
	selectedUI.scale = Vector2(1.25,1.25)
	GRID.add_child(selectedUI)
	selectedUI.hide()
	yield(get_tree(), "idle_frame")
	findOccupiedSpace()
	initializeGame()
	
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
	
func nextTurn():
	var current_index = Game.INITATIVE.find(Game.TURN)
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
	Game.INITATIVE = characters
	Game.TURN = characters[0].name
	turn.text = str(Game.TURN) + "'s Turn"
	rounds.text = str("0")
	for i in Game.INITATIVE.size():
		var label = labelPreload.instance()
		var name = Game.INITATIVE[i].name
		label.text = str(name)
		if name == Game.TURN:
			label.add_color_override("font_color", Color(1, 0, 0, 1))
		initiateGrid.add_child(label)



