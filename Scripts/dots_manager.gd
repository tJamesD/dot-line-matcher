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
	
	_generate_pattern()
	#for dot in pattern:
		#dot._activate()

func _process(delta: float) -> void:
	if animate:
		animate = false
		for dot in pattern:
			dot._activate();
			await get_tree().create_timer(1.0).timeout
	#dot_array[6]._activate()

	
func _generate_pattern():
	pattern = []
	var start_node_index = randf_range(0,8)
	pattern.append(dot_array[start_node_index])
	
	dot_array[start_node_index]._setValid(false)
	
	var temp_neighbors = dot_array[start_node_index]._get_valid_neighbors()
	for i in range(4):
		var neighbor = _pick_random_valid_neighbor(temp_neighbors)
		pattern.append(neighbor)
		temp_neighbors = neighbor._get_valid_neighbors()


func _pick_random_valid_neighbor(neighbor_array):
	if len(neighbor_array) == 0:
		return
	var rand_index = randf_range(0, len(neighbor_array))
	if neighbor_array[rand_index]._isValid():
		neighbor_array[rand_index]._setValid(false)
		return neighbor_array[rand_index]

	while not neighbor_array[rand_index]._isValid():
		rand_index = randf_range(0, len(neighbor_array))
		
	neighbor_array[rand_index]._setValid(false)
	return neighbor_array[rand_index]
		
