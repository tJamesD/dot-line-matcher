extends Control

@onready var current_run_score_label = $CanvasLayer/Score
@onready var data_label = $CanvasLayer/Data

func _ready():
	current_run_score_label.text = "Score: " + str(SaveGames.last_score)
	
	var scores = SaveGames.get_keys()
	
	if scores[0] == null:
		scores[0] = 0
	if scores[1] == null:
		scores[1] = 0
	if scores[2] == null:
		scores[2] = 0
	if scores[3] == null:
		scores[3] = 0
	if scores[4] == null:
		scores[5] = 0
		
	
	
	
	data_label.text = "1: " + str(int(scores[0])) + "\n" + \
					  "2: " + str(int(scores[1])) + "\n" + \
					  "3: " + str(int(scores[2])) + "\n" + \
					  "4: " + str(int(scores[3])) + "\n" + \
					  "5: " + str(int(scores[4])) + "\n"
	
