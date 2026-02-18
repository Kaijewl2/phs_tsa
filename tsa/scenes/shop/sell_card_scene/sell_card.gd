extends Control
class_name SellCard


@export var card_frame: TextureRect


var hovering: bool
var value: int = 100


func _process(_delta: float) -> void:
	if is_mouse_over_card():
		hovering = true
		card_frame.scale = Vector2(1.15, 1.15)
	else:
		hovering = false
		card_frame.scale = Vector2(1, 1)


func is_mouse_over_card():
	var mouse_pos = get_global_mouse_position()
	var card_rect = Rect2(card_frame.global_position, card_frame.texture.get_size())
	return card_rect.has_point(mouse_pos)


func _input(event: InputEvent) -> void:
	# Checks if input is mouse click and mouse is hovering over card
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering and event.is_pressed():
			if GameData.get_balance() >= value:
				GameData.change_balance(value, "subtract")
				print("Card purchased; new balance:", (GameData.get_balance()))
				# Delete card
				self.queue_free()
			else:
				get_tree().get_node("coin_counter") # IP: ADD INSUFFICIENT FUND ANIM
