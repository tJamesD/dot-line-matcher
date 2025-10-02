extends Control

@onready var current_run_score_label = $CanvasLayer/Score
@onready var data_label = $CanvasLayer/Data
@onready var game_over_label = $CanvasLayer/GameOver

func _ready():
	
	current_run_score_label.text = "Score: " + str(SaveGames.last_score) +"\nStreak: " + str(SaveGames.last_best_streak)
	SaveGames._load_scores()
	var scores = SaveGames.get_keys()
	
	var scores_index = scores.size()
	
	while scores_index < 5:
		scores.append({ "score" :0, "streak":0})
		scores_index+=1
			
	data_label.text = "1: " + str(int(scores[0]["score"])) + "/" + str(int(scores[0]["streak"])) + "\n" + \
					  "2: " + str(int(scores[1]["score"])) + "/" + str(int(scores[1]["streak"])) + "\n" + \
					  "3: " + str(int(scores[2]["score"])) + "/" + str(int(scores[2]["streak"])) + "\n" + \
					  "4: " + str(int(scores[3]["score"])) + "/" + str(int(scores[3]["streak"])) + "\n" + \
					  "5: " + str(int(scores[4]["score"])) + "/" + str(int(scores[4]["streak"])) + "\n"
	


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
