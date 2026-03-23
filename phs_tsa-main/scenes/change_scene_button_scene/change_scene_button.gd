extends Control


@export var scene_path: String
@export var label_text: String


@onready var label: Label = $Label


func _ready() -> void:
	label.text = label_text


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(scene_path)
