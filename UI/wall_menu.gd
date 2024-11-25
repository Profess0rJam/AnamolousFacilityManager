extends PopupMenu
signal BuildPlywoodWall
signal BuildWoodWall
signal BuildCinderblockWall
signal BuildReinforcedConcreteWall
signal BuildSteelWall




func _on_index_pressed(index):
	if index == 0:
		BuildPlywoodWall.emit()
	if index == 1:
		BuildWoodWall.emit()
	if index == 2:
		BuildCinderblockWall.emit()
	if index == 3:
		BuildReinforcedConcreteWall.emit()
	if index == 4:
		BuildSteelWall.emit()
