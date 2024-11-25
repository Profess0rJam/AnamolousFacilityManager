extends PopupMenu
signal FloorGravel
signal FloorAsphalt
signal FloorConcrete
signal FloorWood
signal FloorTile




func _on_index_pressed(index):
	if index == 0:
		FloorGravel.emit()
		print("Gravel floor selected for construction")
	if index == 1:
		FloorAsphalt.emit()
	if index == 2:
		FloorConcrete.emit()
	if index == 3:
		FloorWood.emit()
	if index == 4:
		FloorTile.emit()
