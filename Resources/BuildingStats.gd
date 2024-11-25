extends Node

class_name Building
#Base stats for buildings

@export var Cost : int #how much the building costs
@export var Refund : int #how much the building refunds
@export var HealthPoints : int #how many hit poitns the building has

#signal for deletion
signal Deconstruct

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton: #If we are detecting a click on our building
		if get_parent().PlaceMode == 2: #If we are in PlaceMode "2" aka Deconstruction mode
			if Input.is_action_just_pressed("LeftMouseClick"): #if it's specifically a left click
					print("deleting!") #print message for debugging purposes
					Deconstruct.emit() #signal that we want to send to the Main node to get a refund perhaps?
					queue_free() #delete the object
					
