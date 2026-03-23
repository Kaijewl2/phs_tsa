extends Button


@onready var enter_win_scene_button: TextureRect = $".."


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/win_scene/win_scene.tscn")


func _on_mouse_entered() -> void:
	enter_win_scene_button.scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	enter_win_scene_button.scale = Vector2(1.0, 1.0)
