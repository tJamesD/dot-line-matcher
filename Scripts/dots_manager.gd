extends Node2D

enum GameState {ANIMATE, GUESSING, GUESS_FINISHED }

@onready var state : GameState = GameState.ANIMATE

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
@onready var score :int = 0
@onready var dot_1_index = null
@onready var dot_2_index = null
@onready var decrease_time = false

@onready var active_dot = null

@onready var debug_counter =0
@export  var timer_division_amount = 2.0

signal score_increased(amt :int)
signal level_increased(level :int)
signal timer_update(amt :int)
signal game_over()

@export var timer = 30
@export var time_increase_amount : float = 1.5
@onready var second_tracker = 0.0

var animate = true
@export var animation_timer = 0.5
var draw_allowed = false
@export var gen_length : int = 2
var curr_length : int = 0
var decrease_timer = false
var level = 1;

var guess_finished = false

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
		#dot.connect("wrong_pattern", Callable(self,"_reset_to_new_pattern"))
		dot.connect("wrong_pattern", Callable(self,"_handle_bad_guess"))
		dot.connect("correct_pattern", Callable(self,"_increase_score"))
		dot.connect("added_to_user_guess", Callable(self,"_move_draw_window"),CONNECT_DEFERRED)
		dot.connect("added_to_user_guess", Callable(self,"_move_active_dot"),CONNECT_DEFERRED)
	
	_start_round()
	
func _start_round() -> void:
	while curr_length != gen_length:
		_generate_pattern()
	_run_animation()

func _run_animation():
	state = GameState.ANIMATE
	var prev_dot = null	
	for dot in pattern:
		dot.update_color(Color.ORANGE)
		#dot.update_dot_color
		#dot.update_color((Color(0.89,0.49,0,1)))
		if prev_dot != null:
			dot._draw_to_neighbor(prev_dot)
			dot._enable_line()
		prev_dot = dot
		dot._activate();
		await get_tree().create_timer(animation_timer).timeout
	_deactivate_all_dots()
	draw_allowed = true
	curr_length = 0
	state = GameState.GUESSING
	
		
func _process(delta: float) -> void:
	## Update Tiemr
	second_tracker += delta
	if second_tracker >= 1.0:
		#print(timer)
		second_tracker = 0
		timer -= 1
		if timer <= 0:
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
			SaveGames.add_score(score,"Tim")
			
		timer_update.emit(timer)
	
	match state:
		GameState.ANIMATE:
			pass
		GameState.GUESSING:
			_draw_line_to_mouse()
		GameState.GUESS_FINISHED:
			#if active_dot != null:
				#active_dot._reset_mouse_line()
				#active_dot = null
			#dot_1_index = 0
			#dot_2_index = 0
			pass
		
#func _old_process(delta: float) -> void:
	##Update Timer
	#second_tracker += delta
	#if second_tracker >= 1.0:
		##print(timer)
		#second_tracker = 0
		#timer -= 1
		#if timer <= 0:
			#get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
			#SaveGames.add_score(score,"Tim")
			#
		#timer_update.emit(timer)
	## Draw Pattern
	#if animate:
		##print("animate")
		#animate = false
		#for i in range(1):
			#while curr_length != gen_length:
				#_generate_pattern()
			#var prev_dot = null	
			#for dot in pattern:
				#if prev_dot != null:
					#dot._draw_to_neighbor(prev_dot)
					#dot._enable_line()
				#prev_dot = dot
				#dot._activate();
				#await get_tree().create_timer(animation_timer).timeout
			#_deactivate_all_dots()
			#draw_allowed = true
			#curr_length = 0
	#if draw_allowed:
		#print("draw")
		#_draw_line_to_mouse()
	#if guess_finished:
		#print("solution" + str(guess_finished))
		##active_dot = null
		#if active_dot != null:
			#active_dot._reset_mouse_line()
			#active_dot = null
		#for dot in user_guess:
			#dot._reset_line()
		#
		##draw_allowed = false
		#_draw_good_bad_guess(Color.OLIVE_DRAB)
		#await get_tree().create_timer(5.0).timeout
		#if(guess_finished):
			#print("POST WAIT")
			#guess_finished = false
			#_reset_to_new_pattern()
		##guess_finished = false
		#
		### this should be called reset_time_penalty bool or something
		##_reset_to_new_pattern(reset_bool)
		
func _draw_pattern(delta: float) -> void:
	if animate:
		#print("animate")
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
		
			curr_length = 0
		animate = false
		state = GameState.GUESSING

func _draw_good_bad_guess(color :Color):
	#draw_allowed = false
	var prev_dot = null
	for dot in pattern:
		dot.update_dot_color(color)
		dot.update_color(color)
		if prev_dot != null:
			dot._draw_to_neighbor(prev_dot)
			dot._enable_line()
		prev_dot = dot
		#dot._activate();
		
	#get_tree().create_timer(5.0).timeout
	#state = GameState.ANIMATE
	
	#_reset_to_new_pattern(reset_bool)
	#_start_round()
	#_deactivate_all_dots()

func _handle_bad_guess(badGuess : bool):
	decrease_time = badGuess
	draw_allowed = false
	guess_finished = true
	if active_dot != null:
		active_dot._reset_mouse_line()
		active_dot = null
	state = GameState.GUESS_FINISHED
	_draw_good_bad_guess(Color.ORANGE_RED)
	var timer = get_tree().create_timer(.35)
	timer.timeout.connect(_on_post_guess)

func _increase_gen_count():
	match score:
		5:
		#2:
			#level2
			gen_length +=1
			level +=1
			time_increase_amount = 2.15
			timer+=10
			level_increased.emit(level)

		#4:
		10: 
			#level3
			gen_length +=1
			level +=1
			time_increase_amount = 2.75
			timer+=10
			level_increased.emit(level)
		#6:
		15:
			#level4
			gen_length +=1
			level +=1
			time_increase_amount = 3.35
			timer+=15
			timer_division_amount = 1.5
			level_increased.emit(level)
			
		#8:
		25:
			#level5
			gen_length +=1
			level +=1
			time_increase_amount = 3.95
			timer+=20
			level_increased.emit(level)

		#10:
		35: 
			#level6
			gen_length +=1
			level +=1
			time_increase_amount = 4.55
			timer+=20
			timer_division_amount = 1.25
			level_increased.emit(level)


		#12:
		45:
			#level 7
			gen_length +=1
			level +=1
			time_increase_amount = 4.75
			timer+=25
			animation_timer -= 0.05
			level_increased.emit(level)

		#14:
		55:
			#level 8
			gen_length +=1
			level +=1
			time_increase_amount = 4.85
			timer+=40
			animation_timer -= 0.05
			timer_division_amount = 1.0
			level_increased.emit(level)
			
		65:
			level +=1
			time_increase_amount = 4.5
			animation_timer -= 0.05
			timer_division_amount = .75
			level_increased.emit(level)
		75:
			level +=1
			time_increase_amount = 4.25
			animation_timer -= 0.05
			timer_division_amount = .5
			level_increased.emit(level)
		85:
			level +=1
			time_increase_amount = 4.0
			animation_timer -= 0.05
			timer_division_amount = .25
			level_increased.emit(level)
			


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

func _draw_line_to_mouse():
	if active_dot != null:
		if(debug_counter % 100 == 0):
			pass
			#print("LINE DOT: " + active_dot.name)
		#debug_counter += 1
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
		dot._reset_mouse_motion_count()
		

func _increase_score():
	#_set_green_line()
	#await get_tree().create_timer(.3).timeout
	#self.modulate(Color = )
	score += 1
	_increase_gen_count()
	score_increased.emit(score)
	timer += time_increase_amount
	#print(score)
	#increaseScore.emit(amt)
	
	#pause and actually draw last dot.
	_move_draw_window()
	active_dot._reset_mouse_line()
	active_dot = null
	await get_tree().create_timer(.3).timeout
	
	draw_allowed = false
	guess_finished = true
	state = GameState.GUESS_FINISHED
	_draw_good_bad_guess(Color.GOLD)
	var timer = get_tree().create_timer(.35)
	timer.timeout.connect(_on_post_guess)
	#_reset_to_new_pattern(false)
	#_reset_line()
	
func _on_post_guess():
	_reset_to_new_pattern()	
	_start_round()
func _reset_to_new_pattern():
	
	#_draw_good_bad_guess()
	
	_reset_neighbor_status()
	_deactivate_all_dots()
	dot_1_index = 0
	dot_2_index = 0
	
	user_guess.clear()
	animate = true
	draw_allowed = false
	guess_finished =false
	active_dot = null
	
	if decrease_time:
		decrease_time = false
		print("TIME DECREASED")
		timer -= time_increase_amount / timer_division_amount
		
#func _set_green_line():
	#for dot in user_guess:
		#dot.update_color(Color.DARK_BLUE)
		#dot.update_dot_color(Color.DARK_BLUE)
#func _set_red_line():
	#for dot in user_guess:
		#dot.update_color(Color.RED)
		#dot.update_dot_color(Color.RED)
#
#func _reset_line():
	#var dot_color = Color(1,1,1,1)
	#for dot in user_guess:
		#dot.update_color(Color.ORANGE)
		#
		#dot.update_dot_color(dot_color)
		
