extends ProgressBar


@onready var ram_info_rect: ColorRect = $ram_info_rect


func _on_mouse_entered() -> void:
	ram_info_rect.show()


func _on_mouse_exited() -> void:
	ram_info_rect.hide()
