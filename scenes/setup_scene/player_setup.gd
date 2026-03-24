extends Node2D


@onready var active_cards_container: Control = $"../active_cards_container"
@onready var h_box_container: HBoxContainer = $"../active_cards_container/HBoxContainer"


const HAND_COUNT = 3
const WALKING_BOT_CARD_SCENE_PATH = "res://scenes/setup_card_scene/setup_card.tscn"
const CARD_WIDTH = 200
const HAND_Y_POSITION = 890

var player_hand = []
var center_screen_x


func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

	GameData.setup_changed.connect(load_cards_from_setup)
	load_cards_from_setup()


# Called automatically whenever GameData.add_card_to_setup(str) is called
func add_card_to_setup(card):
	card.sell_card_data = GameData.setup_card_types[GameData.setup_cards.find(card)]
	h_box_container.add_child(card)
	if card not in player_hand:
		player_hand.insert(0, card)


func load_cards_from_setup():
	for card in h_box_container.get_children():
		card.queue_free()
	player_hand.clear()
	
	var temp = 0
	
	for card_path in GameData.setup_cards:
		var card_scene = load(card_path)
		var setup_card = card_scene.instantiate()
		setup_card.sell_card_data = GameData.setup_card_types[temp]
		h_box_container.add_child(setup_card)
		
		temp+=1


func load_cards_from_backpack():
	player_hand.clear()
	
	for card_path in GameData.player_hand_cards:
		var card_scene = load(card_path)
		var card = card_scene.instantiate()
		
		add_card_to_setup(card)
