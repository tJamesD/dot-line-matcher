extends Node

var score_dict = {}
var score_array = []
var equal 
var last_score = 0

var save_path = "user://highscores.save"

func _ready():
	_load_scores()

func add_score(score: int, name: String):
	last_score = score
	if _check_max_scores():
		#score_dict.set(score, name)
		score_array.append({"name":name, "score" :score})
	elif _check_for_new_high_score(score):
		score_array.append({"name":name, "score" :score})
		score_array.sort_custom(_custom_sort)
		score_array.remove_at(score_array.size()-1)
		
		
	
	_save_score()

func _custom_sort(a_dict, b_dict):
	## hopefully new score wipes the old score.
	if a_dict["score"] > b_dict["score"]:
		return true
	return false
		

func _save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(score_array))
	file.close()
	
func _load_scores():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var scores = JSON.parse_string(content)
		score_array = scores
		print(score_array)

func _check_max_scores():
	#return score_dict.size() <= 5 
	return score_array.size() < 5

func _check_for_new_high_score(new_score :int):
	var new_high_score = false
	for entry in score_array:
		if new_score > entry["score"]:
			new_high_score = true
			break;
	return new_high_score

func get_keys() -> Array:
	var retArr = []
	for dict in score_array:
		retArr.append(dict["score"])
	return retArr;
