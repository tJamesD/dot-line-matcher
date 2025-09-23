extends Control

@onready var data_label = $CanvasLayer/Data

func _ready():
	
	SaveGames._load_scores()
	var scores = SaveGames.get_keys()
	
	var scores_index = scores.size()
	
	while scores_index < 5:
		scores.append(0)
		scores_index+=1
			
	data_label.text = "1: " + str(int(scores[0])) + "\n" + \
					  "2: " + str(int(scores[1])) + "\n" + \
					  "3: " + str(int(scores[2])) + "\n" + \
					  "4: " + str(int(scores[3])) + "\n" + \
					  "5: " + str(int(scores[4])) + "\n"

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
