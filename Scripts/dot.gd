extends Area2D

class_name Dot

var activated : bool = false
var isValid : bool = true
var neighbors = []

@onready var sprite = $Circle
#@onready var line = $Line
@onready var line = Line2D.new()
#@onready var dot_manager = get_parent()


func _ready():
	#line.scale = Vector2(1.0/ scale.x, 1.0/scale.y)
	line.width = 150
	line.z_index = 1
	line.default_color = Color.ORANGE
	add_child(line)
	

func _on_mouse_entered() -> void:
	#likely change, will be do other things, method will handled activaiton
	#sprite.modulate = Color(0.89,0.49,0,1)
	#if not dot_manager.animate:
		#_activate()
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

func _draw_to_neighbor(dot: Dot):
	line.points = [to_local(dot.position), to_local(global_position)]

#rename to _disable_line
func _reset_line():
	#line.visible = false
	line.clear_points()

func _enable_line():
	line.visible = true
