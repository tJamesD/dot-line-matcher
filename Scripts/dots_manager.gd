extends Node

@onready var dot_array
@onready var pattern
@onready var dot0 = $Dot0
@onready var dot1 = $Dot1
@onready var dot2 = $Dot2
@onready var dot3 = $Dot3
@onready var dot4 = $Dot4
@onready var dot5 = $Dot5
@onready var dot6 = $Dot6
@onready var dot7 = $Dot7
@onready var dot8 = $Dot8
var animate = true
@export var gen_length : int = 9
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
	
	#dot_array[2]._draw_to_neighbor(dot_array[4])
	
	#_generate_pattern()
	#for dot in pattern:
		#dot._activate()

func _process(delta: float) -> void:

	if animate:
		animate = false
		for i in range(2):
			while curr_length != gen_length:
				_generate_pattern()
			var prev_dot = null	
			for dot in pattern:
				if prev_dot != null:
					dot._draw_to_neighbor(prev_dot)
					dot._enable_line()
				prev_dot = dot
				dot._activate();
				await get_tree().create_timer(1.0).timeout
			_deactivate_all_dots()
			curr_length = 0
	#dot_array[6]._activate()

	
func _generate_pattern():
	pattern = []
	print("Pattern0: " + str(pattern))
	curr_length = 0
	_reset_neighbor_status()
	var start_node_index : int = randf_range(0,8)
	pattern.append(dot_array[start_node_index])
	curr_length += 1
	print("Pattern1: " + str(pattern))
	
	dot_array[start_node_index]._setValid(false)
	print("Start DOT0: " + str(start_node_index))
	var temp_neighbors = dot_array[start_node_index]._get_valid_neighbors()
	print("valid Neights of start dot: " + str(temp_neighbors))
	for i in range(gen_length):
		var neighbor = _pick_random_valid_neighbor(temp_neighbors)
		if neighbor != null:
			print("next neighbor: " + neighbor.name)
		if neighbor == null:
			return
		pattern.append(neighbor)
		print("Pattern2: " + str(pattern))
		curr_length += 1
		temp_neighbors = neighbor._get_valid_neighbors()
		print("next Neighbors: " + str(temp_neighbors))


func _pick_random_valid_neighbor(neighbor_array):
	print("Neighbor_Array: " + str(neighbor_array))
	if len(neighbor_array) == 0:
		return
	var rand_index : int = randf_range(0, len(neighbor_array))
	#print("Rand DOT: " + str(rand_index))
	print("START DOT1: " + neighbor_array[rand_index].name)
	if neighbor_array[rand_index]._isValid():
		print("ISVALID: " + neighbor_array[rand_index].name)
		neighbor_array[rand_index]._setValid(false)
		return neighbor_array[rand_index]

	while not neighbor_array[rand_index]._isValid():
		print("ATTEMPT: " + neighbor_array[rand_index].name)
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
