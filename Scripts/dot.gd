extends Area2D

class_name Dot

var activated : bool = false
var isValid : bool = true
var neighbors = []

@onready var sprite = $Circle

func _on_mouse_entered() -> void:
	#likely change, will be do other things, method will handled activaiton
	#sprite.modulate = Color(0.89,0.49,0,1)
	pass

func _on_mouse_exited() -> void:
	pass
	#sprite.modulate = Color(1,1,1,1)
	
func _activate() -> void:
	sprite.modulate = Color(0.89,0.49,0,1)
	activated = true
	
func _deactivate() -> void:
	sprite.modulate = Color(1,1,1,1)
	activated = false
	
func _set_neighbors(dots : Array):
	neighbors = []
	for dot in dots:
		neighbors.append(dot)

func _get_neighbors():
	return neighbors

func _get_valid_neighbors():
	var valid_neighbors = []
	for neigh in neighbors:
		if neigh._isValid():
			valid_neighbors.append(neigh)
	return valid_neighbors

func _isValid():
	return isValid

func _setValid(parm :bool):
	isValid = parm
