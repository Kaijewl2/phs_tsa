extends Button


@onready var enter_shop_button: TextureRect = $".."


func _on_mouse_entered() -> void:
	enter_shop_button.scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	enter_shop_button.scale = Vector2(1.0, 1.0)
