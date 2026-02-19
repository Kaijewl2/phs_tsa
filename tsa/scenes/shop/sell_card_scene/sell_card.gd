extends Control
class_name SellCard


@export var card_frame: TextureRect
@export var value: int = 100


var hovering: bool
var press_count: int
var coin_counter_original_pos: Vector2
var is_first_shake = true 
var shake_tween: Tween = null


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
				var coin_counter: Control = get_parent().get_parent().get_node("coin_counter")
				coin_counter.get_node("AnimationPlayer").play("insufficient_funds")
				anim_shake(coin_counter)
				
				if press_count >= 10:
					var brick: Control = get_parent().get_parent().get_node("brick")
					brick.show()
					await get_tree().create_timer(2.0).timeout
					brick.hide()
					
					press_count = 0
				
func anim_shake(node):
	if is_first_shake:
		coin_counter_original_pos = node.position
		is_first_shake = false
	
	# Kill previous tween
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	
	# Always shake from the saved original position
	shake_tween = create_tween()
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(-10, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(10, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(-5, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(5, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos, 0.05)
	press_count+=1
