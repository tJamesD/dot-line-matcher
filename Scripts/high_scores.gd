extends Control

@onready var data_label = $CanvasLayer/Data

func _ready():
	
	SaveGames._load_scores()
	#var scores = SaveGames.get_keys()
	
	var scores = SaveGames.score_array
	
	var scores_index = scores.size()
	
	while scores_index < 5:
		scores.append({ "score" :0, "streak":0})
		scores_index+=1
			
	data_label.text = "" + str(int(scores[0]["score"])) + "               " + str(int(scores[0]["streak"])) + "\n" + \
					  "" + str(int(scores[1]["score"])) + "               " + str(int(scores[1]["streak"])) + "\n" + \
					  "" + str(int(scores[2]["score"])) + "               " + str(int(scores[2]["streak"])) + "\n" + \
					  "" + str(int(scores[3]["score"])) + "               " + str(int(scores[3]["streak"])) + "\n" + \
					  "" + str(int(scores[4]["score"])) + "               " + str(int(scores[4]["streak"])) + "\n"

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
