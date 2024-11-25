extends Node2D

func _on_new_game_button_pressed(): #When the new game button is pressed, load the main scene
	get_tree().change_scene_to_file("res://Scenes and Scripts/UI/main.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes and Scripts/UI/credits.tscn")
