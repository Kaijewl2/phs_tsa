extends Node


signal balance_changed(new_balance)
signal hand_changed(new_card)
signal backpack_changed()
signal deck_changed()
signal setup_changed()


const MAX_BACKPACK_SIZE = 15
const MAX_SETUP_SIZE = 3


var active_units = []
var active_commrades = []
var active_enemies = []
var player_hand_cards = []

var deck_cards = []
var setup_cards = []
var backpack_cards = []
var balance: int
var PlayerClass: String


func _ready() -> void:
	if player_hand_cards.is_empty():
		for i in range(MAX_BACKPACK_SIZE - 3):
			add_card_to_backpack("res://scenes/setup_card_scene/setup_card.tscn")
		
		for i in range(1):
			add_card_to_setup(backpack_cards[i])


func get_active_units():
	return active_units


func get_active_commrades():
	return active_commrades


func get_active_enemies():
	return active_enemies


func get_player_hand_cards():
	return player_hand_cards


func get_balance():
	return balance


func get_player_class():
	return PlayerClass


func add_card_to_backpack(card_path:String):
	backpack_cards.append(card_path)
	backpack_changed.emit()


func add_card_to_deck(card_path:String):
	if deck_cards.size() <= MAX_BACKPACK_SIZE:
		deck_cards.append(card_path)
		deck_changed.emit()
		return true
	return false
	
func add_card_to_setup(card_path:String):
	if setup_cards.size() < MAX_SETUP_SIZE:
		active_units.append(card_path)
		setup_cards.append(card_path)
		setup_changed.emit()
		return true
	return false


func remove_card_from_deck(card_path: String):
	deck_cards.erase(card_path)
	deck_changed.emit()
	

func remove_card_from_setup(card_path: String):
	setup_cards.erase(card_path)
	active_units.erase(card_path)
	setup_changed.emit()


func add_card_to_array(card_path:String):
	player_hand_cards.push_back(card_path)
	
	var card_scene = load(card_path)
	var card = card_scene.instantiate()
	
	# Emit most recently added card as argument
	hand_changed.emit(card)


func change_balance(value, operation):
	if operation == "add" :
		balance += value
	elif operation == "subtract":
		balance -= value
	elif  operation == "divide":
		balance /= value
	elif operation == "multiply":
		balance *= value

	balance_changed.emit(balance)


func change_player_class(new_class:String):
	PlayerClass = new_class
