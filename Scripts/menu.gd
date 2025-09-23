extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_high_scores_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/high_scores.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
