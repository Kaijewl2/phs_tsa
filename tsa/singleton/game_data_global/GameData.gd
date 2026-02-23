extends Node


signal balance_changed(new_balance)
signal hand_changed(new_card)


var active_units = []
var active_commrades = []
var active_enemies = []
var player_hand_cards = []
var balance: int


func _ready() -> void:
	if player_hand_cards.is_empty():
		for i in range(3):
			add_card_to_array("res://scenes/card_scenes/card_scene/card.tscn")


func get_active_units():
	return active_units


func get_active_commrades():
	return active_commrades


func get_active_enemies():
	return active_enemies


func get_player_hand_cards():
	print("Gobal array of cards: ")
	for i in player_hand_cards:
		print("card: ", i)

	
	return player_hand_cards


func get_balance():
	return balance


func add_card_to_array(card_path:String):
	print("fired add_card_to_array and added: ", card_path)
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
