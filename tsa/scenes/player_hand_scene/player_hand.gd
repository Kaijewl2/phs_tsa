extends Node2D


@onready var card_manager: Node2D = $"../card_manager"


const HAND_COUNT = 4
const WALKING_BOT_CARD_SCENE_PATH = "res://scenes/card_scenes/card_scene/card.tscn"
const SCIENTIST_CARD_SCENE_PATH = "res://scenes/entity_scenes/scientist_scene/scientist_card.tscn"
const CARD_WIDTH = 200
const HAND_Y_POSITION = 890

var player_hand = []
var center_screen_x


func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	var walking_bot_card_scene = preload(WALKING_BOT_CARD_SCENE_PATH)
	var scientist_card_scene = preload(SCIENTIST_CARD_SCENE_PATH)
	
	for i in range(HAND_COUNT):
		var new_walking_bot_card = walking_bot_card_scene.instantiate()
		var new_scientist_card = scientist_card_scene.instantiate()
		
		card_manager.add_child(new_walking_bot_card)
		card_manager.add_child(new_scientist_card)
		
		new_walking_bot_card.name = "walking_bot_card"
		new_scientist_card.name = "scientist_card"
		
		add_card_to_hand(new_walking_bot_card)
		add_card_to_hand(new_scientist_card)


func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)


func update_hand_positions():
	for i in range(player_hand.size()):
		# Get new card position based on index passed in
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		
		card.hand_position = new_position
		
		animate_card_to_position(card, new_position)


func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	
	return x_offset


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	
	tween.tween_property(card, "position", new_position, 0.1)
	
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		
		update_hand_positions()
