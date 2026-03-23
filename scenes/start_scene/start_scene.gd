extends Control


@onready var play_button: Button = $buttons_container/play_button
@onready var settings_button: Button = $buttons_container/settings_button
@onready var quit_button: Button = $buttons_container/quit_button


func _on_play_button_mouse_entered() -> void:
	play_button.scale = Vector2(1.05, 1.05)


func _on_play_button_mouse_exited() -> void:
	play_button.scale = Vector2(1.0, 1.0)


func _on_settings_button_mouse_entered() -> void:
	settings_button.scale = Vector2(1.05, 1.05)


func _on_settings_button_mouse_exited() -> void:
	settings_button.scale = Vector2(1.0, 1.0)


func _on_quit_button_mouse_entered() -> void:
	quit_button.scale = Vector2(1.05, 1.05)


func _on_quit_button_mouse_exited() -> void:
	quit_button.scale = Vector2(1.0, 1.0)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/choose_class_scene/choose_class_scene.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_scene/settings_scene.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
