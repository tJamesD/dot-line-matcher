extends Control

@onready var soundLabel = $CanvasLayer/Sound
@onready var SFXLabel = $CanvasLayer/SFX

func _ready():
	SettingsData._load_data()
	if SettingsData.soundBool:
		soundLabel.text = "Sound:\nOn"
	else:
		soundLabel.text = "Sound:\nOff"
	
	if SettingsData.sfxBool:
		SFXLabel.text = "SFX:\nOn"
	else:
		SFXLabel.text = "SFX:\nOff"
	


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_reset_high_scores_pressed() -> void:
	SaveGames.reset_high_scores()


func _on_sound_pressed() -> void:
	## will need to save to file.
	#SettingsData._load_data()
	if SettingsData.soundBool:
		SettingsData.soundBool = false
		soundLabel.text = "Sound:\nOff"
	else:
		SettingsData.soundBool = true
		soundLabel.text = "Sound:\nOn"
		
	SettingsData._save_data()
		
func _on_sfx_pressed() -> void:
	## will need to save to file.
	#SettingsData._load_data()
	if SettingsData.sfxBool:
		SettingsData.sfxBool = false
		SFXLabel.text = "SFX:\nOff"
	else:
		SettingsData.sfxBool = true
		SFXLabel.text = "SFX:\nOn"
	
	SettingsData._save_data()
