extends Control


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_reset_high_scores_pressed() -> void:
	SaveGames.reset_high_scores()
