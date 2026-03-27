extends Control


func _on_button_pressed() -> void:
	GameData.reset()
	get_tree().change_scene_to_file("res://scenes/start_scene/start_scene.tscn")
