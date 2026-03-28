extends Control


@export var scene_path: String
@export var label_text: String


@onready var label: Label = $Label


func _ready() -> void:
	label.text = label_text


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(scene_path)


func _on_button_mouse_entered() -> void:
	scale = Vector2(1.03, 1.03)


func _on_button_mouse_exited() -> void:
	#modulate = Color.
	scale = Vector2(1.0, 1.0)
