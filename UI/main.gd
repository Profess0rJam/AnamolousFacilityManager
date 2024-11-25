extends Node2D

#Variables for floor and building construction
var BuildingTile #Holds the ID of the floor tile we want to build
var BuildTileLayer #holds the layer ID of the tile we want to build
var BuildingTileCost #Cost of placing the tile
var TargetBuildingTilePosition : Vector2 #The position on the map that we want to place the tile at
var BuildingObject #Holds ID of the object we want to build
var BuildingObjectCost #Cost of building the object
var TargetBuildingObjectPosition #the position on the map that we want to place the object at
var CurrentExpense #temporarily stores the current price of the thing being built
#var FloorLayer = $TilesAndBuildings/FloorLayer #hold the floor tile layer so I can easily refer to it
#var BuildingLayer = $TilesAndBuildings/BuildingLayer #hold the building layer

func _ready(): #Things that need to happen when the game starts
	$Time/TimeBar/OptionButton.select(0) #Set game speed to normal
	$Time/TimeBar/DayTimer.start() #Set the day to 0
	$Time/TimeBar/UnpauseButton.hide()
	$MoneyAndBuilding/FundsLabel.text = "Funds: " + str(Funds)
	$EventWindow/StartGamePopUp.show() #Show intro message
	get_tree().paused = true #Pause everything

func _process(_delta): #Things happening every single frame
	$Time/TimeBar.set_value(DayProgress) #Update the progress bar for the current day
	if DayProgress >= 100: #At the end of each day...
		NewDayTimeReset() #Run the new day function
		ExpenseTotal()#Figure out the expense total
		ExpenseSubtraction()#Subtract expenses from funds
		print("It's a new day, yes it is!") #Print a New Day reference in the console because it makes me happy

#Keeping track of time
var DayNumber: int = 0 #Keeping track of what day it is
var DayProgress : float = 0 #Setting the progress for the individual day
func NewDayTimeReset(): #Function that is called at the start of each new day
	DayNumber +=1 #Increment the day number by 1
	DayProgress = 0 #reset progress of the day
	$Time/TimeBar/Label.text = "Day " + str(DayNumber) #Update the label to tell us what day it is

func _on_option_button_item_selected(index): #Effects of changing the time
	if index == 0: #If "Normal speed is selected
		Engine.time_scale = 1 #Reset time_scale to default value
		$MapCamera.CameraSpeedAdjustment = 1 #make sure camera is moving at default rate
	if index == 1: #If fast forward is selected
		Engine.time_scale = 3 #Time moves forward thrice as fast
		$MapCamera.CameraSpeedAdjustment = 0.3 #Since we're going three times as fast, we need to divide camera speed by 3
	if index == 2: #If slow motion is enabled
		Engine.time_scale = 0.2 #We move at 20% speed
		$MapCamera.CameraSpeedAdjustment = 5 #Since we're going a fifth the speed, the camera needs to move 5 times as fast

func _on_day_timer_timeout(): #When the day timer times out, advance progress by 1. Currently one second
	DayProgress += 1

func _on_pause_button_pressed(): #When pause button is pressed
	get_tree().paused = true #Pause everything
	$Time/TimeBar/PauseButton.hide() #Hide the pause button
	$Time/TimeBar/UnpauseButton.show() #Show the unpause button

func _on_unpause_button_pressed(): #When the unpause button is pressed
	get_tree().paused = false #unpause the game
	$Time/TimeBar/UnpauseButton.hide() #hide the unpause button
	$Time/TimeBar/PauseButton.show() #Show the pause button

#Finances
var Funds : int = 250 #How much money you start with
var DailySubsidy : int = 250 #Default starting subsidy
var DailyCost : int = 0
var ExpensesArray = [1] #Where staff salaries and other daily payments will be stored, placeholder of 1 so that it isn't null

func GroupExpenses(accum, number): #Storing the value of the expenses grouped together
	return accum + number 

func ExpenseTotal(): #Get the sum of all expenses 
	DailyCost = ExpensesArray.reduce(GroupExpenses,0) #The DailyCost variable is equal to the sum of the ExpensesArray
	
func ExpenseSubtraction():
	Funds -= DailyCost #Subtract the daily costs from the Funds
	DailyCost = 0 #Reset DailyCost so it doesn't exponentially increase
	print("You have " + str(Funds) + " remaining funds")
	$MoneyAndBuilding/FundsLabel.text = "Funds: " + str(Funds)


#Floor Construction Code

func _on_tiles_send_the_bill(Expense):
	Funds -= Expense
	$MoneyAndBuilding/FundsLabel.text = "Funds: " + str(Funds)
