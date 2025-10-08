extends Node

var settings_dict = {}
#var settings_dict = {"sound": true, "sfx": true}
var settings_path = "user://settings.data"

var soundBool = true
var sfxBool = true


func _ready():
	_load_data()


func _load_data():
	if FileAccess.file_exists(settings_path):
		var file = FileAccess.open(settings_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var settings = JSON.parse_string(content)
		if settings != null:
			print(settings)
			settings_dict = settings
			soundBool = settings_dict["sound"]
			sfxBool = settings_dict["sfx"]
			print(settings_dict)
	else:
		_save_data()
	print("LOADED")
	print(settings_dict)

		
		#var parse_result = JSON.parse_string(content)
		#if parse_result != null:
			#settings_dict = parse_result  # this is the actual Dictionary
			#soundBool = settings_dict["sound"]
			#sfxBool = settings_dict["sfx"]
#
		#print(settings_dict)
		
func _save_data():
	print("SAVING DATA")
	settings_dict["sound"] = soundBool
	settings_dict["sfx"] = sfxBool
	var file = FileAccess.open(settings_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings_dict))
	file.close()
	
#func set_sound(passedBool : bool):
	#soundBool = passedBool
	#
#func set_sfx(passedBool : bool):
	#sfxBool = passedBool
	
