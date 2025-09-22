extends Node2D

@onready var dot_array
@onready var pattern
@onready var user_guess = []
@onready var dot0 = $Dot0
@onready var dot1 = $Dot1
@onready var dot2 = $Dot2
@onready var dot3 = $Dot3
@onready var dot4 = $Dot4
@onready var dot5 = $Dot5
@onready var dot6 = $Dot6
@onready var dot7 = $Dot7
@onready var dot8 = $Dot8
@onready var score = 0
@onready var dot_1_index = null
@onready var dot_2_index = null

@onready var active_dot = null

@onready var debug_counter =0

signal score_increased(amt :int)
signal level_increased(level :int)
signal timer_update(amt :int)
signal game_over()

@onready var timer = 60
@export var time_increase_amount = 2
@onready var second_tracker = 0.0

var animate = true
@export var animation_timer = 0.5
var draw_allowed = false
@export var gen_length : int = 2
var curr_length : int = 0


func _ready():
	dot_array = [dot0, dot1, dot2, dot3, dot4, dot5, dot6, dot7, dot8]
	dot_array[0]._set_neighbors([dot1, dot3, dot4])
	dot_array[1]._set_neighbors([dot0, dot2, dot3, dot4, dot5])
	dot_array[2]._set_neighbors([dot1, dot4, dot5])
	dot_array[3]._set_neighbors([dot0, dot1, dot4, dot6, dot7])
	dot_array[4]._set_neighbors([dot0, dot1, dot2, dot3, dot5, dot6, dot7, dot8])
	dot_array[5]._set_neighbors([dot1, dot2, dot4, dot7, dot8])
	dot_array[6]._set_neighbors([dot3, dot4, dot7])
	dot_array[7]._set_neighbors([dot3, dot4, dot5, dot6, dot8])
	dot_array[8]._set_neighbors([dot4, dot5, dot7])
	
	for dot in dot_array:
		dot.connect("wrong_pattern", Callable(self,"_reset_to_new_pattern"))
		dot.connect("correct_pattern", Callable(self,"_increase_score"))
		dot.connect("added_to_user_guess", Callable(self,"_move_draw_window"),CONNECT_DEFERRED)
		dot.connect("added_to_user_guess", Callable(self,"_move_active_dot"),CONNECT_DEFERRED)
		#dot.connect("current_dot", Callable(self,"_draw_line_to_mouse"))
	
	#dot_array[2]._draw_to_neighbor(dot_array[4])
	
	#_generate_pattern()
	#for dot in pattern:
		#dot._activate()
	#second_tracker += Time.get_unix_time_from_system()
		
func _process(delta: float) -> void:
	
	second_tracker += delta
	if second_tracker >= 1.0:
		print(timer)
		second_tracker = 0
		timer -= 1
		if timer <= 0:
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
			
		timer_update.emit(timer)
	
	if animate:
		animate = false
		for i in range(1):
			while curr_length != gen_length:
				_generate_pattern()
			var prev_dot = null	
			for dot in pattern:
				if prev_dot != null:
					dot._draw_to_neighbor(prev_dot)
					dot._enable_line()
				prev_dot = dot
				dot._activate();
				await get_tree().create_timer(animation_timer).timeout
			_deactivate_all_dots()
			draw_allowed = true
			curr_length = 0
	if draw_allowed:
		_draw_line_to_mouse()
		
func _increase_gen_count():
	match score:
		5:
			gen_length +=1
			level_increased.emit(gen_length)
		10: 
			gen_length +=1
			level_increased.emit(gen_length)
		15:
			gen_length +=1
			level_increased.emit(gen_length)
		25:
			gen_length +=1
			level_increased.emit(gen_length)
		35: 
			gen_length +=1
			level_increased.emit(gen_length)
		45:
			gen_length +=1
			level_increased.emit(gen_length)
		55:
			gen_length +=1
			level_increased.emit(gen_length)

func _move_active_dot():
	if active_dot != null :
		active_dot._reset_mouse_line()
	
	user_guess[-1].mouse_active_dot = true
	
	active_dot = user_guess[-1]

func _move_draw_window():
	print("USER_GUESSES: " + str(user_guess))
	#print("DOt1: " + str(dot_1_index) + " DOT2: " + str(dot_2_index))
	if len(user_guess) == 1:
		dot_1_index = 0
	elif len(user_guess) == 2:
		dot_2_index = 1
		user_guess[dot_1_index]._draw_to_neighbor(user_guess[dot_2_index])
	elif len(user_guess)  > 2:
		dot_1_index +=1
		dot_2_index +=1
		#print("DOt1_1: " + str(dot_1_index) + "DOT2_2: " + str(dot_2_index))
		user_guess[dot_1_index]._draw_to_neighbor(user_guess[dot_2_index])

	
#func _search_mouse_active_dot() -> Dot:
	#
	#for dot in dot_array:
		#if dot.mouse_active_dot:
			#return dot
	#return null
	



func _user_guess_index_checker():
	pass
	

func _draw_line_to_mouse():
	#var dot = _search_mouse_active_dot()
	#var dot = null
	#
	#var dot_1 = null
	#var dot_2 = null
	#
	#if dot_1_index != null:
		#dot_1 = user_guess[dot_1_index]
	#print(dot)
	if active_dot != null:
		if(debug_counter % 100 == 0):
			pass
			#print("LINE DOT: " + active_dot.name)
		#debug_counter += 1
		#print(dot.position)
		#print(get_viewport().get_mouse_position())
		#var local_mouse = dot.get_parent().to_local(get_viewport().get_mouse_position())
		#dot.line_to_mouse.global_position = Vector2.ZERO
		#dot.line_to_mouse.points = [dot.global_position, get_viewport().get_mouse_position()]
		#dot.line_to_mouse.global_position = Vector2.ZERO
		#dot.line_to_mouse.points = [dot.position, get_viewport().get_mouse_position()]
		
		#var local_mouse = dot.get_parent().to_local(get_viewport().get_mouse_position())
		#dot.line_to_mouse.points = [dot.global_position, get_global_mouse_position()]
		var start_local = active_dot.to_local(active_dot.global_position)
		if get_viewport() != null: 
			var end_local   = active_dot.to_local(get_viewport().get_mouse_position())
			active_dot.line_to_mouse.points = [start_local, end_local]
	

func _generate_pattern():
	pattern = []
	#print("Pattern0: " + str(pattern))
	curr_length = 0
	_reset_neighbor_status()
	var start_node_index : int = randf_range(0,8)
	pattern.append(dot_array[start_node_index])
	curr_length += 1
	#print("Pattern1: " + str(pattern))
	
	dot_array[start_node_index]._setValid(false)
	#print("Start DOT0: " + str(start_node_index))
	var temp_neighbors = dot_array[start_node_index]._get_valid_neighbors()
	#print("valid Neights of start dot: " + str(temp_neighbors))
	for i in range(gen_length-1):
		var neighbor = _pick_random_valid_neighbor(temp_neighbors)
		#if neighbor != null:
			##print("next neighbor: " + neighbor.name)
		if neighbor == null:
			return
		pattern.append(neighbor)
		#print("Pattern2: " + str(pattern))
		curr_length += 1
		temp_neighbors = neighbor._get_valid_neighbors()
		#print("next Neighbors: " + str(temp_neighbors))
	print("PATTERN: " + str(pattern))


func _pick_random_valid_neighbor(neighbor_array):
	#print("Neighbor_Array: " + str(neighbor_array))
	if len(neighbor_array) == 0:
		return
	var rand_index : int = randf_range(0, len(neighbor_array))
	#print("Rand DOT: " + str(rand_index))
	#print("START DOT1: " + neighbor_array[rand_index].name)
	if neighbor_array[rand_index]._isValid():
		#print("ISVALID: " + neighbor_array[rand_index].name)
		neighbor_array[rand_index]._setValid(false)
		return neighbor_array[rand_index]

	while not neighbor_array[rand_index]._isValid():
		#print("ATTEMPT: " + neighbor_array[rand_index].name)
		rand_index = randf_range(0, len(neighbor_array)-1)
		
	neighbor_array[rand_index]._setValid(false)
	return neighbor_array[rand_index]
		

func _reset_neighbor_status():
	for dot in dot_array:
		dot._setValid(true)

func _deactivate_all_dots():
	for dot in dot_array:
		dot._deactivate()
		dot._reset_line()
		dot._reset_mouse_line()

func _increase_score():
	score += 1
	_increase_gen_count()
	score_increased.emit(score)
	timer += time_increase_amount
	#print(score)
	#increaseScore.emit(amt)
	#_move_draw_window()
	_reset_to_new_pattern()
	
		
func _reset_to_new_pattern():
	_reset_neighbor_status()
	_deactivate_all_dots()
	dot_1_index = 0
	dot_2_index = 0
	
	user_guess.clear()
	animate = true
	draw_allowed = false
	active_dot = null
