extends Node2D

onready var grid = preload("res://Scenes/Utility Scenes/1.tscn")
onready var selectedUi = preload("res://Assets/Images/SelectedUI.png")

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
enum characterEnum {
	KZSHANTJI,
	ZONSHRA
}
var selectedCharacter
var selectedGrids = 0
var maxGrids = 6 # default
var is_pressed = false
var speedDefault = 30
var spawned = false

# characters 
var kzshantji
var zonshra

var selectedUI = Sprite.new()
var controlUI = Sprite.new()

# warning-ignore:shadowed_variable
func modulateGrids(moveableGrid: Array):
	for child in $Grid.get_children():
				if child is TextureButton:
					var gridNum = int(child.get_name()) + 1
					# Check if the gridNum is in the moveableGrid array
					if moveableGrid.find(gridNum) != -1:
						child.modulate = Color("#9d13582b")  # Modulate color for accessible grids
					else:
						child.modulate = Color("#4e160c0c")  # Modulate color for non-accessible grids


# warning-ignore:shadowed_variable
# warning-ignore:unused_argument
# warning-ignore:shadowed_variable
func onPressed(grid, gridName):
	is_pressed = true
	Game.movePos = grid.rect_position  # Print movePos before connecting the signal
	Game.gridPos = int(gridName) + 1
	print("I'll move to , ",Game.gridPos)
	print("MovePos before connecting signal:", Game.movePos)

	var zone = grid.get_node("detectionZone")
	overlappingBodies = zone.get_overlapping_bodies()

	if overlappingBodies.size() > 0:
		var name = overlappingBodies[0].name
		$UI/debug.text = str(name) + " Selected" if name != null else ""
		match name:
			"Kzshantji":
				selectedCharacter = characterEnum.KZSHANTJI
				moveableGrid = find_accessible_range(int(Game.gridPos), 30, Game.zonshraPos)
				modulateGrids(moveableGrid)
			"Zonshra":
				selectedCharacter = characterEnum.ZONSHRA
				moveableGrid = find_accessible_range(int(Game.gridPos), 30, Game.kzshantjiPos)
				modulateGrids(moveableGrid)
			
	else:
		$UI/debug.text = ""

	if is_pressed and not spawned:
		controlUI.texture = selectedUi
		controlUI.scale = Vector2(1.25, 1.25)
		controlUI.position = Game.movePos + Vector2(20, 20)
		$Grid.add_child(controlUI)
		spawned = true
		controlUI.show()
	else: 
		controlUI.position = Game.movePos + Vector2(20, 20)

func movePressed():
	var isMoveable = moveableGrid.find(Game.gridPos) != -1
	if isMoveable:
		match selectedCharacter:
			characterEnum.KZSHANTJI:
				kzshantji.position = Game.movePos + Vector2(20, 20)
				for child in $Grid.get_children():
					if child is TextureButton:
						child.modulate = Color("#4e160c0c")
			characterEnum.ZONSHRA:
				zonshra.position = Game.movePos + Vector2(20, 20)
				for child in $Grid.get_children():
					if child is TextureButton:
						child.modulate = Color("#4e160c0c")
	else:
		print("Invaild Move!")
		$UI/debug.text = "Invalid Move!"
	
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
	columns = $Grid.columns
	rows = columns
	width = gridRange * columns
	height = gridRange * rows
	area = rows * columns
	$UI/range.text = str(width) + " x " + str(height)
	$UI/debug.text = str(selectedGrids)
	
	for i in range(0,int(area)):
		var gridInstance = grid.instance()
		gridInstance.set_name(str(i))
		$Grid.add_child(gridInstance)
		gridInstance.connect("pressed",self,"onPressed",[gridInstance,gridInstance.name])
		gridInstance.connect("mouse_entered",self,"onMouseEntered",[gridInstance])
		gridInstance.connect("mouse_exited",self,"onMouseExited",[gridInstance])
		
	for j in $Grid.get_children():
		if j is KinematicBody2D:
			characters.append(j)

	for character in characters:
		if character.get_name() == "Kzshantji":
			kzshantji = character
		elif character.get_name() == "Zonshra":
			zonshra = character

# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	$UI/Undo.connect("pressed",self,"undoPressed")
	$UI/Move.connect("pressed", self, "movePressed")
		
	selectedUI.texture = selectedUi
	selectedUI.scale = Vector2(1.25,1.25)
	$Grid.add_child(selectedUI)
	selectedUI.hide()
	
func find_accessible_range(selected_number: int, movementRange: int, ignore_number: int) -> Array:
	var accessible_numbers: Array = []
	
	# Calculate row and column
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
			if num != selected_number and num != ignore_number:
				accessible_numbers.append(num)
	
	return accessible_numbers

func _process(delta):
	for child in $Grid.get_children():
		if child is TextureButton:
			var zone = child.get_node("detectionZone")
			overlappingBodies = zone.get_overlapping_bodies()
			if overlappingBodies.size() > 0:
				var name = overlappingBodies[0].name
				match name:
					"Zonshra":
						Game.zonshraPos = int(child.get_name()) + 1
					"Kzshantji":
						Game.kzshantjiPos = int(child.get_name()) + 1






