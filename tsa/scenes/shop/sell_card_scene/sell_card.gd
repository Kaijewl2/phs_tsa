extends Control
class_name SellCard


@export var card_frame: TextureRect
@export var value: int = 100


@onready var player_hand = get_tree().get_first_node_in_group("player_hand")


const SELL_CARD_PATH: String = "res://scenes/shop/sell_card_scene/sell_card.tscn"
const SETUP_CARD_PATH: String = "res://scenes/setup_card_scene/setup_card.tscn"
const WALKING_BOT_CARD_SCENE_PATH: String = "res://scenes/card_scenes/card_scene/card.tscn"


var hovering: bool
var press_count: int
var coin_counter_original_pos: Vector2
var is_first_shake = true 
var shake_tween: Tween = null
var card_frame_scale: Vector2


func _ready() -> void:
	card_frame_scale = card_frame.scale


func _process(_delta: float) -> void:
	if is_mouse_over_card():
		hovering = true
		card_frame.scale = Vector2(card_frame_scale.x + 0.15, card_frame_scale.y + 0.15)
	else:
		hovering = false
		card_frame.scale = card_frame_scale


func is_mouse_over_card():
	var mouse_pos = get_global_mouse_position()
	var card_rect = Rect2(card_frame.global_position, card_frame.texture.get_size())
	return card_rect.has_point(mouse_pos)


func _input(event: InputEvent) -> void:
	# Checks if input is mouse click and mouse is hovering over card
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering and event.is_pressed():
			# Successful purchase
			if GameData.get_balance() >= value && GameData.backpack_cards.size() < GameData.MAX_BACKPACK_SIZE:
				GameData.change_balance(value, "subtract")
				
				# Add card to player's backpack
				GameData.add_card_to_backpack(SETUP_CARD_PATH)
				
				# Delete card
				self.queue_free()
			# Insufficient funds
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
