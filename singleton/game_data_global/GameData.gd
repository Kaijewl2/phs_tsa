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
var setup_card_types = []
var backpack_cards = []
var backpack_card_types = []

var balance: int
var PlayerClass: String
var unit_types = {
	"penguin": preload("uid://1p5h1g0b1o30"),
	"cat": preload("uid://dd8sqowg4kx7p"),
}
var sell_card_types = {
	"penguin": preload("uid://ctslcvel45hud"),
	"cat": preload("uid://2kvmrlos8s2h"),
}


func _ready() -> void:
	if player_hand_cards.is_empty():
		add_card_to_backpack("res://scenes/setup_card_scene/setup_card.tscn", sell_card_types["cat"])
		
		if backpack_cards.size() > 0:
			add_card_to_setup(backpack_cards[0], backpack_card_types[0])


func get_unit_id(unit_id:String):
	if unit_types.has(unit_id):
		return unit_types[unit_id]
	return "no valid unit"


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


# Add sell correct sell card to backpack when purchased
func add_card_to_backpack(card_path:String, card_type:SellCardData):
	print("adding card type: ", card_type)
	backpack_cards.append(card_path)
	backpack_card_types.append(card_type)
	backpack_changed.emit()


func add_card_to_setup(card_path:String, card_type:SellCardData):
	if setup_cards.size() < MAX_SETUP_SIZE:
		active_units.append(card_path)
		setup_cards.append(card_path)
		setup_card_types.append(card_type)
		setup_changed.emit()
		return true
	return false


func add_card_to_deck(card_path:String):
	if deck_cards.size() <= MAX_BACKPACK_SIZE:
		deck_cards.append(card_path)
		deck_changed.emit()
		return true
	return false
	

func remove_card_from_deck(card_path: String):
	deck_cards.erase(card_path)
	deck_changed.emit()
	

func remove_card_from_setup(card_path: String):
	setup_cards.erase(card_path)
	active_units.erase(card_path)
	setup_changed.emit()


func remove_card_from_backpack(card_path: String):
	var index = backpack_cards.find(card_path)
	if index != -1:
		backpack_cards.remove_at(index)
		backpack_card_types.remove_at(index)
		
	backpack_changed.emit()


func add_card_to_array(card_path:String):
	player_hand_cards.push_back(card_path)
	
	var card_scene = load(card_path)
	var card = card_scene.instantiate()
	
	# Emit most recently added card as argument
	hand_changed.emit(card)


func get_random_entity_data():
	var unit_list = unit_types.values()
	
	return unit_list.pick_random()


func get_random_sell_card_data():
	var sell_card_list = sell_card_types.values()
	
	return sell_card_list.pick_random()


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


func move_backpack_card_to_setup(card_path:String):
	var index = backpack_cards.find(card_path)

	if index == -1:
		return false

	var card_type = backpack_card_types[index]

	if add_card_to_setup(card_path, card_type):
		backpack_cards.remove_at(index)
		backpack_card_types.remove_at(index)
		backpack_changed.emit()
		return true

	return false


func change_player_class(new_class:String):
	PlayerClass = new_class
