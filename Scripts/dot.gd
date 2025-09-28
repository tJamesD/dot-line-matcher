extends Area2D

class_name Dot

var activated : bool = false
var isValid : bool = true
var neighbors = []

signal wrong_pattern(inverse_time:bool)
signal correct_pattern
signal added_to_user_guess

var mouse_motion_count = 0

var mouse_active_dot : bool = false
#signal current_dot(dot :Dot)

@onready var sprite = $Circle
@onready var dot_manager = get_parent()
@onready var line2dtest = Line2D.new()
@onready var line_to_mouse = Line2D.new()


func _ready():
	#line.scale = Vector2(1.0/ scale.x, 1.0/scale.y)
	line2dtest.width = 150
	line2dtest.z_index = 1

	var line_color = Color.ORANGE
	var semi_transparent = Color(line_color.r, line_color.g, line_color.b, 0.75)
	line2dtest.default_color = line_color
	add_child(line2dtest)
	
	line_to_mouse.width = 150
	line_to_mouse.z_index = 1
	line_to_mouse.default_color = line_color
	add_child(line_to_mouse)
	

#func _on_mouse_entered() -> void:
	#if dot_manager.draw_allowed:
		##mouse_active_dot = true
		#_activate()
		##current_dot.emit(self)
		#if dot_manager.user_guess.count(self) == 0:
			#dot_manager.user_guess.append(self)
			##print("SELFCHECK: " + str(dot_manager.user_guess))
			#_check_solution()

func _check_solution():
	var index : int = 0
	print("USER GUESSES2: " + str(dot_manager.user_guess))
	for dot in dot_manager.user_guess:
		#print("USER_GUESS NAME: " + dot.name + " PATTERNAME: " + dot_manager.pattern[index].name)
		if dot != dot_manager.pattern[index]:
			print("Wrong Guess!!!")
			wrong_pattern.emit(true)
			return;
		index+=1
	
	if len(dot_manager.pattern) == len(dot_manager.user_guess):
		dot_manager.state = dot_manager.GameState.GUESS_FINISHED
		correct_pattern.emit()
	elif (len(dot_manager.user_guess) > 0 ):
		added_to_user_guess.emit()

func update_color(color: Color):
	line2dtest.default_color = color
	line_to_mouse.default_color = color
	#self.modulate = color
	
func update_dot_color(color : Color):
	#sprite.modulate = Color(1,1,1,1)
	sprite.modulate = color
##func _on_mouse_exited() -> void:
	#pass
	##sprite.modulate = Color(1,1,1,1)
	
func _activate() -> void:
	#sprite.modulate = Color(0.89,0.49,0,1
	sprite.modulate = Color.ORANGE
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
	
func _reset_mouse_line():
	line_to_mouse.clear_points()
	mouse_active_dot = false
	
func _reset_mouse_motion_count():
	mouse_motion_count = 0
	

func _enable_line():
	pass
	#line2dtest.visible = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if dot_manager.state != dot_manager.GameState.GUESSING or dot_manager.guess_finished:
		return
	#if (not dot_manager.draw_allowed) or dot_manager.guess_finished:
		#return
	# PC: hover/move with button held down
	elif event is InputEventMouseMotion and mouse_motion_count <1:
		## remove moust_motion_count
		mouse_motion_count += 1;
		print("AAAA")
		_handle_activation()
	# PC: click
	elif event is InputEventMouseButton and event.pressed:
		#print("BBBB")
		_handle_activation()

	# Mobile: tap/hold
	elif event is InputEventScreenTouch and event.pressed:
		#print("CCCC")
		_handle_activation()

	# Mobile: drag across
	elif event is InputEventScreenDrag:
		#print("DDDD")
		_handle_activation()


func _handle_activation() -> void:
	if len(dot_manager.user_guess) < dot_manager.gen_length:
		_activate()

		if dot_manager.user_guess.count(self) == 0:
			dot_manager.user_guess.append(self)
			print("CHECKSOLUTION")
			_check_solution()
