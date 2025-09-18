extends Sprite2D

@export var follow_mouse = false

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var dir = mouse_pos - global_position
	
	# Rotate toward mouse
	rotation = dir.angle()
	
	# Distance from object to mouse
	var dist = dir.length()
	
	# Scale along x-axis depending on distance
	scale.x = dist / 100.0   # adjust divisor for sensitivity
	scale.y = 1              # keep y fixed
	
func _draw_between_dots(dot1 :Dot, dot2:Dot):
	pass
