extends Node2D

class_name TilesAndBuildings
#have the different layers ready for reference
@onready var FloorLayer : TileMapLayer = $FloorLayer
@onready var BuildingLayer : TileMapLayer = $BuildingLayer

#States and related variables
var ConstructFloors #State for constructing floors, which are just tiles
var ConstructBuildings #State for constructing buildings, which are fixed, immovable objects in the game world
var Deconstruct #Mode for deconstructing buildings
enum States {ConstructFloors,ConstructBuildings,Deconstruct,Looking} #An enum to hold all of the different possible states
var PlaceMode = States.Looking #Looking is the default state that just has the player looking at things, there's no special input for it
var OldMode #Variable used to store the previous state, specifically when someone mouses over a menu. This prevents clicking through UI elements and marking on the map

#For holding values related to construction
var BuildingTile #Tile we would like to apply to the target location
var BuildingObject #Object we would like to build at the target location
var Expense : int #store the expense amount

#Arrays for holding map elements
var BuildingArray : Array
#Signals
signal SendTheBill #signal used to send expense data to main scene

#Preload Objects
@onready var PlywoodWall = preload("res://Scenes and Scripts/Buildings/PlywoodWall.tscn")
@onready var CinderblockWall = preload("res://Scenes and Scripts/Buildings/CinderblockWall.tscn")
@onready var WoodWall = preload("res://Scenes and Scripts/Buildings/WoodWall.tscn")
@onready var ReinforcedConcreteWall = preload("res://Scenes and Scripts/Buildings/ReinforcedConcreteWall.tscn")
@onready var SteelWall = preload("res://Scenes and Scripts/Buildings/SteelWall.tscn")


func _process(_delta: float):
	#Things that need to update every frame:
	var MousePosition : Vector2i = get_global_mouse_position() #Checking where the mouse position is
	
	$"../MoneyAndBuilding/StateLabel".text = "Game Mode " + str(PlaceMode)
	#Input handling
	if(Input.is_action_just_pressed("LeftMouseClick")):
		match PlaceMode: 
			States.ConstructFloors: #Check to see if we're specifically in the mode for constructing floors
				if MousePosition.x <8015 and MousePosition.x >0 and MousePosition.y > 0 and MousePosition.y < 8016: #requirements so that we can't build things off of the map
					SetTileAtMouse(0,0,BuildingTile) #When we click, if we are in BuildingFloor game state, we will put the tile onto the tile we click
			States.ConstructBuildings:
				if MousePosition.x <8015 and MousePosition.x >0 and MousePosition.y > 0 and MousePosition.y < 8016: #requirements so that we can't build things off of the map
					ConstructBuildingAtMouse()
			States.Deconstruct:
				pass
	if(Input.is_action_just_pressed("RightMouseClick")):
		PlaceMode = States.Looking
		print("Mouse Position is " + str(MousePosition))
	
#Constructing and Deconstructing
func SetTileAtMouse(_Layer: int = 0, ID : int = 0, Type: Vector2 = Vector2(0,0)): #Layer, source ID (I think?), Atlas coordinates
	if PlaceMode == States.ConstructFloors: 
		FloorLayer.set_cell(FloorLayer.local_to_map(get_global_mouse_position()), ID, Type)
		SendTheBill.emit(Expense)#Charge for floor placement
	else:
		print("Curious")
		pass

func ConstructBuildingAtMouse(): #function for making a building at mouse position at click
	if PlaceMode == States.ConstructBuildings:
		var BuildingMousePosition : Vector2i = get_global_mouse_position() #Checking where the mouse position is
		var DesiredXPosition = floor(BuildingMousePosition.x / 16) * 16 #adjusting the x position by grid size
		var DesiredYPosition = floor(BuildingMousePosition.y / 16) * 16 #adjusting the y position by grid size
		var TargetLocation = Vector2(DesiredXPosition, DesiredYPosition)
		var BuildingObjectInstance = BuildingObject.instantiate()
		add_child(BuildingObjectInstance)
		BuildingArray.append(BuildingObjectInstance)
		print(BuildingArray)
		BuildingObjectInstance.position = TargetLocation
		print("Desired X and Y positions are" + str(DesiredXPosition) + " " + str(DesiredYPosition))
		SendTheBill.emit(Expense)


#Menus sending signals so they don't have buildings happening under them
func _on_menu_bar_mouse_entered(): #When you hover over part of the menu, you enter the looking game state so you can't build behind menu buttons
	OldMode = PlaceMode #Save the previous state 
	PlaceMode = States.Looking
	
func _on_floor_menu_mouse_entered():
	OldMode = PlaceMode #Save the previous state 
	PlaceMode = States.Looking

func _on_wall_menu_mouse_entered():
	OldMode = PlaceMode #Save the previous state 
	PlaceMode = States.Looking

func _on_deconstruct_button_mouse_entered():
	OldMode = PlaceMode #Save the previous state 
	PlaceMode = States.Looking

func _on_menu_bar_mouse_exited():
	PlaceMode = OldMode #When you exit the menu bar, return to the state you were in

#Floors
func _on_floor_menu_floor_gravel():
	BuildingTile = Vector2(0,0)
	Expense = 1
	PlaceMode = States.ConstructFloors

func _on_floor_menu_floor_asphalt():
	BuildingTile = Vector2(1,0)
	Expense = 2
	PlaceMode = States.ConstructFloors
	
func _on_floor_menu_floor_concrete():
	BuildingTile = Vector2(2,0)
	Expense = 3
	PlaceMode = States.ConstructFloors
	
func _on_floor_menu_floor_wood():
	BuildingTile = Vector2(3,0)
	Expense = 5
	PlaceMode = States.ConstructFloors

func _on_floor_menu_floor_tile():
	BuildingTile = Vector2(4,0)
	Expense = 5
	PlaceMode = States.ConstructFloors

#Walls
func _on_wall_menu_build_plywood_wall():
	BuildingObject = PlywoodWall
	Expense = 1
	PlaceMode = States.ConstructBuildings
	

func _on_wall_menu_build_wood_wall():
	BuildingObject = WoodWall
	Expense = 3
	PlaceMode = States.ConstructBuildings

func _on_wall_menu_build_cinderblock_wall():
	BuildingObject = CinderblockWall
	Expense = 3
	PlaceMode = States.ConstructBuildings

func _on_wall_menu_build_reinforced_concrete_wall():
	BuildingObject = ReinforcedConcreteWall
	Expense = 8
	PlaceMode = States.ConstructBuildings

func _on_wall_menu_build_steel_wall():
	BuildingObject = SteelWall
	Expense = 15
	PlaceMode = States.ConstructBuildings


func _on_deconstruct_button_deconstruct_on():
	PlaceMode = States.Deconstruct
	
func _on_deconstruct_button_deconstruct_off():
	PlaceMode = States.Looking
