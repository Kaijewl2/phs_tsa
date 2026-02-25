extends Control

const SELF_PATH = "res://scenes/setup_card_scene/setup_card.tscn"

var card_path: String


@onready var texture_rect: TextureRect = $TextureRect
@onready var button: Button = $Button


func setup(path: String):
	card_path = path


func _on_mouse_entered() -> void:
	button.show()


func _on_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()


func _on_button_mouse_entered() -> void:
	button.show()


func _on_button_mouse_exited() -> void:
	button.hide()


func _on_button_pressed() -> void:
	print("remove card")
	GameData.remove_card_from_setup(SELF_PATH)
	#GameData.add_card_to_backpack(SELF_PATH)
