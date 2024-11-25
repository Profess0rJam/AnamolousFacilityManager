extends AcceptDialog

func _on_confirmed():
	get_tree().paused = false #unpause the game

func _on_canceled():
	get_tree().paused = false #unpause the game
