extends Control


var card_path: String


@onready var texture_rect: TextureRect = $TextureRect
@onready var button: Button = $Button


func setup(path: String):
	card_path = path
	button.pressed.connect(add_to_setup)
	
func add_to_setup():
	if GameData.add_card_to_setup(card_path):
		print("Added to deck!")
		queue_free()
	else:
		print("Deck full!")


func _on_button_mouse_entered() -> void:
	button.show()


func _on_button_mouse_exited() -> void:
	button.hide()


func _on_texture_rect_mouse_entered() -> void:
	button.show()


func _on_texture_rect_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()
