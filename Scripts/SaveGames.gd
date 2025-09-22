extends Node

var score_dict = {}

var save_path = "user://highscores.save"

func _ready():
	_load_scores()

func add_score(score: int, name: String):
	score_dict.set(score, name)
	_save_score()

func _save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(score_dict))
	file.close()
	
func _load_scores():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var scores = JSON.parse_string(content)
		score_dict = scores
		print(score_dict)
		
