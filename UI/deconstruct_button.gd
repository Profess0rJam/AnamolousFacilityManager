extends CheckButton

signal DeconstructOn
signal DeconstructOff

var IsButtonPressed : bool = false

func _on_pressed():
	if IsButtonPressed == false:
		DeconstructOn.emit()
		IsButtonPressed = true
		print("Deconstruction mode on")
	else:
		IsButtonPressed = false
		DeconstructOff.emit()
		print("Deconstruction mode off")
