extends Area2D

class_name Dot

var activated : bool = false
var isValid : bool = true
var neighbors = []

signal wrong_pattern
signal correct_pattern

@onready var sprite = $Circle
@onready var dot_manager = get_parent()
@onready var line2dtest = Line2D.new()


func _ready():
	#line.scale = Vector2(1.0/ scale.x, 1.0/scale.y)
	line2dtest.width = 150
	line2dtest.z_index = 1
	line2dtest.default_color = Color.ORANGE
	add_child(line2dtest)
	

func _on_mouse_entered() -> void:
	#likely change, will be do other things, method will handled activaiton
	#sprite.modulate = Color(0.89,0.49,0,1)
	if dot_manager.draw_allowed:
		_activate()
		if dot_manager.user_guess.count(self) == 0:
			dot_manager.user_guess.append(self)
		_check_solution()

func _check_solution():
	var index : int = 0
	for dot in dot_manager.user_guess:
		if dot != dot_manager.pattern[index]:
			print("Wrong Guess!!!")
			wrong_pattern.emit()
			break;
		index+=1
	if len(dot_manager.pattern) == len(dot_manager.user_guess):
		correct_pattern.emit()
	

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
	#var dot_pos = dot.global_position
	#var line_dir =  dot_pos - line.global_position
	#rotation = line_dir.angle()
	#var dist = line_dir.length()
	#
	#line.scale.x = dist / 15   # adjust divisor for sensitivity
	line2dtest.points = [to_local(dot.position), to_local(global_position)]
	
	#this throws errors and needs fixing.
	

#rename to _disable_line
func _reset_line():
	line2dtest.clear_points()

func _enable_line():
	pass
	#line2dtest.visible = true
