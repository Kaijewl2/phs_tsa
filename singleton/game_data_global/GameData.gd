extends Node


signal balance_changed(new_balance)
signal hand_changed(new_card)
signal backpack_changed()
signal deck_changed()
signal setup_changed()


const MAX_BACKPACK_SIZE = 15
const MAX_SETUP_SIZE = 3
const MAX_RAM_SLOTS:int = 4
const BOSS_INTERVAL:int = 4
const FINAL_BOSS_ROUND:int = 5
const SETUP_CARD_SCENE_PATH:String = "res://scenes/setup_card_scene/setup_card.tscn"
const BACKPACK_RAM_STICK_SCENE_PATH:String = "res://scenes/backpack_ram_scene/backpack_ram.tscn"


var backpack_items = []
var active_units = []
var active_commrades = []
var active_enemies = []
var player_hand_cards = []
var deck_cards = []
var setup_cards = []
var setup_card_types = []
var setup_rams = []
var setup_ram_types = []
var backpack_cards = []
var backpack_card_types = []
var battle_number:int = 1
var current_security_sweep:int = 1
var added_starting_card:bool = false
var balance: int = 676767
var PlayerClass: String
var unit_types = {
	"penguin": preload("uid://1p5h1g0b1o30"),
	"cat": preload("uid://dd8sqowg4kx7p"),
}
var sell_card_types = {
	"penguin": preload("uid://ctslcvel45hud"),
	"cat": preload("uid://2kvmrlos8s2h"),
}
var harware_part_types = {
	"damage_ram": preload("uid://d1yj44foo08a0"),
	"speed_ram": preload("uid://djv75ht8apx3y"),
	"health_ram": preload("uid://dtqn1dmjrrb1g")
}
var minor_virus_names = ["Trojan Commanders", "Spyware Syndicates", "Botnet Breachers", "Adware Swarm"]
var boss_virus_names = ["Ransomware Tyrant", "Kernel Hydra", "Malware Prime", "Backdoor Kingpin"]
var final_virus_names = ["Singularity Virus", "Root Admin", "Black Hat", "Eternal Botnet"]


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


func increment_security_sweep():
	current_security_sweep+=1


func is_boss_encounter() -> bool:
	return battle_number % BOSS_INTERVAL == 0


func is_final_boss_encounter() -> bool:
	return battle_number % FINAL_BOSS_ROUND == 0


func add_starting_card():
	if player_hand_cards.is_empty():
		print("Player class: ", PlayerClass)
		#add_card_to_backpack(SETUP_CARD_SCENE_PATH, sell_card_types["cat"])
		if(PlayerClass == "linux"):
			add_card_to_setup(SETUP_CARD_SCENE_PATH, sell_card_types["penguin"])
		elif(PlayerClass == "mac"):
			add_card_to_setup(SETUP_CARD_SCENE_PATH, sell_card_types["cat"])
		else:
			add_card_to_setup(SETUP_CARD_SCENE_PATH, sell_card_types["cat"])
			
		added_starting_card = true


# Add sell correct sell card to backpack when purchased
func add_card_to_backpack(card_path:String, card_type:SellCardData):
	print("adding card to backpack: ", card_type)
	backpack_items.append({ "path": card_path, "data": card_type, "type": "card" })
	backpack_changed.emit()


# Add correct RAM stick to backpack when purchased
func add_ram_stick_to_backpack(ram_path: String, ram_type: RamData):
	backpack_items.append({ "path": ram_path, "data": ram_type, "type": "ram" })
	backpack_changed.emit()


func add_card_to_setup(card_path:String, card_type:SellCardData):
	if setup_cards.size() < MAX_SETUP_SIZE:
		active_units.append(card_path)
		setup_cards.append(card_path)
		setup_card_types.append(card_type)
		setup_changed.emit()
		return true
	return false


func add_ram_stick_to_setup(ram_stick_path:String, ram_stick_type:RamData):
	if setup_rams.size() < MAX_RAM_SLOTS:
		setup_rams.append(ram_stick_path)
		setup_ram_types.append(ram_stick_type)
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
	

func remove_card_from_setup(card_type: SellCardData):
	var index = setup_card_types.find(card_type)
	
	if index != -1:
		setup_cards.remove_at(index)
		setup_card_types.remove_at(index)
		active_units.remove_at(index)
	else:
		print("remove_card_from_setup(card_type): no index found")
	setup_changed.emit()


func remove_ram_from_setup(ram_type: RamData):
	var index = setup_ram_types.find(ram_type)
	
	if index != -1:
		setup_rams.remove_at(index)
		setup_ram_types.remove_at(index)
		add_ram_stick_to_backpack(BACKPACK_RAM_STICK_SCENE_PATH, ram_type)
	else:
		print("remove_card_from_setup(card_type): no index found")
	setup_changed.emit()


func remove_card_from_backpack(card_path: String):
	for i in range(backpack_items.size() - 1, -1, -1):
		if backpack_items[i]["path"] == card_path:
			backpack_items.remove_at(i)
			break
	backpack_changed.emit()


func add_card_to_array(card_path:String):
	player_hand_cards.push_back(card_path)
	
	var card_scene = load(card_path)
	var card = card_scene.instantiate()
	
	# Emit most recently added card as argument
	hand_changed.emit(card)


func get_ram_stat_bonuses() -> Dictionary:
	var bonuses = {
		"damage": 0.0,
		"speed": 0.0,
		"health": 0.0
	}
	for ram in setup_ram_types:
		bonuses["damage"] += ram.damage_enhancer
		bonuses["speed"] += ram.speed_enhancer
		bonuses["health"] += ram.health_enhancer
	return bonuses


func get_random_minor_virus_name():
	return minor_virus_names.pick_random()


func get_random_boss_virus_name():
	return boss_virus_names.pick_random()


func get_random_final_boss_virus_name():
	return final_virus_names.pick_random()


func get_random_entity_data():
	var unit_list = unit_types.values()
	
	return unit_list.pick_random()


func get_random_sell_card_data():
	var sell_card_list = sell_card_types.values()
	
	return sell_card_list.pick_random()


func get_random_hardware_part_data():
	var harware_part_list = harware_part_types.values()
	
	return harware_part_list.pick_random()


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


func move_backpack_card_to_setup(card_type: SellCardData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "card" and item["data"] == card_type:
			if add_card_to_setup(item["path"], card_type):
				backpack_items.remove_at(i)
				backpack_changed.emit()
				return true
	return false


func move_ram_stick_to_setup(ram_stick_type: RamData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "ram" and item["data"] == ram_stick_type:
			if add_ram_stick_to_setup(item["path"], ram_stick_type):
				backpack_items.remove_at(i)
				backpack_changed.emit()
				return true
	return false


func change_player_class(new_class:String):
	PlayerClass = new_class
