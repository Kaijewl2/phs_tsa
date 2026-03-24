extends Button


@onready var loss_restart_button: TextureRect = $".."


func _on_pressed() -> void:
	GameData.reset()
	
	get_tree().change_scene_to_file("res://scenes/start_scene/start_scene.tscn")


func _on_mouse_entered() -> void:
	loss_restart_button.scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	loss_restart_button.scale = Vector2(1.0, 1.0)
