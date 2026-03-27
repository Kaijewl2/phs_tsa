extends Node


signal balance_changed(new_balance)
signal hand_changed(new_card)
signal backpack_changed()
signal deck_changed()
signal setup_changed()
signal ram_changed()


const MAX_BACKPACK_SIZE = 15
const MAX_SETUP_SIZE = 67
const MAX_RAM_SLOTS:int = 4
const BOSS_INTERVAL:int = 3
const FINAL_BOSS_ROUND:int = 10
const SETUP_CARD_SCENE_PATH:String = "res://scenes/setup_card_scene/setup_card.tscn"
const BACKPACK_RAM_STICK_SCENE_PATH:String = "res://scenes/backpack_ram_scene/backpack_ram.tscn"
const BACKPACK_GPU_SCENE_PATH: String = "res://scenes/backpack_gpu_scene/backpack_gpu.tscn"
const BACKPACK_CPU_SCENE_PATH: String = "res://scenes/backpack_cpu/backpack_cpu.tscn"
const MAX_GPU_SLOTS: int = 1
const MAX_CPU_SLOTS: int = 1
const MAX_RAM_GB:int = 32
const BASE_RAM_STICK_DATA = preload("uid://c8mwxgju7ai6q")
const HEALTH_RAM_STICK_DATA = preload("uid://dtqn1dmjrrb1g")
const DAMAGE_RAM_STICK_DATA = preload("uid://d1yj44foo08a0")
const SPEED_RAM_STICK_DATA = preload("uid://djv75ht8apx3y")

enum Context {NORMAL, REMOVE}


var current_context = Context.NORMAL
var current_cutscene:int = 0
var setup_gpus = []
var setup_cpus = []
var setup_gpu_types = []
var setup_cpu_types = []
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
var added_starting_ram: bool = true
var tutorial_played: bool = false
var user_skipped_tutorial: bool = false
var balance: int = 50
var current_ram_gb: int
var PlayerClass: String
var unit_types = {
	"Tux": preload("uid://1p5h1g0b1o30"),
	"Firecat": preload("uid://dd8sqowg4kx7p"),
	"GNU": preload("uid://baft574watmnq"),
	"Rubber Ducky": preload("uid://bcr6xqbvc4ute"),
	"Red Hat": preload("uid://bbmitl70fosjs"),
	"White Hat": preload("uid://6o1dwqoutta7"),
	"Trojan Horse": preload("uid://de314auxcnjap")
}
var normal_virus_types = {
	"Packet Sniffer": preload("uid://i6pn4tgjed20"),
	"Phony Phisherman": preload("uid://2wj5vnnkqmh"),
	"Keylogger Grunt": preload("uid://c583jidam0ntk"),
	"Malware Minion": preload("uid://ctjr6w40k7jkc")
}
var boss_virus_types = {
	"Ransomware Tyrant": preload("uid://ctg5o3qcackfs"),
	"Kernel Hydra": preload("uid://0geme0386ctt"),
	"Backdoor Kingpin": preload("uid://d4gtehvklamj4")
}
var final_virus_types = {
	"The Great Corruption": preload("uid://cxehqlbcpi28")
}
var sell_card_types = {
	"Tux": preload("uid://ctslcvel45hud"),
	"Firecat": preload("uid://2kvmrlos8s2h"),
	"GNU": preload("uid://c7s7gv5or1lrs"),
	"Rubber Ducky": preload("uid://cgqbgddys2rng"),
	"Red Hat": preload("uid://broqflxgwfqus"),
	"White Hat": preload("uid://dxtpcwur872cf"),
	"Trojan Horse": preload("uid://ctie5077o8jbp")
}
var harware_part_types = {
	"damage_ram": preload("uid://d1yj44foo08a0"),
	"speed_ram": preload("uid://djv75ht8apx3y"),
	"health_ram": preload("uid://dtqn1dmjrrb1g"),
	"base_ram": preload("uid://c8mwxgju7ai6q")
}
var gpu_types = {
	"damage_gpu": preload("uid://dcss64215a6ww"),
	"speed_gpu": preload("uid://bafbjwry44ic5"),
	"health_gpu": preload("uid://daf61snfrfxjs"),
}
var cpu_types = {
	"damage_cpu": preload("uid://cmyb285lel60r"),
	"speed_cpu": preload("uid://yqqgnc4gswl"),
	"health_cpu": preload("uid://fsrci6pogw1b"),
}
var minor_virus_names = ["Trojan Commanders", "Spyware Syndicates", "Botnet Breachers", "Adware Swarm"]
var boss_virus_names = ["Ransomware Tyrant", "Kernel Hydra", "Zero Day Phantom", "Backdoor Kingpin"]
var final_virus_names = ["The Great Corruption"]

func _ready() -> void:
	load_audio_settings()


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


func add_starting_gear():
	if player_hand_cards.is_empty():
		add_ram_stick_to_backpack(BACKPACK_RAM_STICK_SCENE_PATH, BASE_RAM_STICK_DATA)
		if(PlayerClass == "cat"):
			add_card_to_backpack(SETUP_CARD_SCENE_PATH, sell_card_types["Firecat"])
		elif(PlayerClass == "penguin"):
			add_card_to_backpack(SETUP_CARD_SCENE_PATH, sell_card_types["Tux"])
		else:
			add_card_to_backpack(SETUP_CARD_SCENE_PATH, sell_card_types["Rubber Ducky"])
		
		added_starting_card = true
		added_starting_ram = true


# Add sell correct sell card to backpack when purchased
func add_card_to_backpack(card_path:String, card_type:SellCardData):
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


func add_gpu_to_backpack(gpu_path: String, gpu_type: GpuData):
	backpack_items.append({ "path": gpu_path, "data": gpu_type, "type": "gpu" })
	backpack_changed.emit()


func add_cpu_to_backpack(cpu_path: String, cpu_type: CpuData):
	backpack_items.append({ "path": cpu_path, "data": cpu_type, "type": "cpu" })
	backpack_changed.emit()


func add_card_to_deck(card_path:String):
	if deck_cards.size() <= MAX_BACKPACK_SIZE:
		deck_cards.append(card_path)
		deck_changed.emit()
		return true
	return false


func add_card_to_array(card_path:String):
	player_hand_cards.push_back(card_path)
	
	var card_scene = load(card_path)
	var card = card_scene.instantiate()
	
	# Emit most recently added card as argument
	hand_changed.emit(card)


func add_current_ram(ram_data:RamData):
	var ram_gb = ram_data.gb_size
	
	current_ram_gb += ram_gb
	
	ram_changed.emit()


func add_card_ram(card_data: SellCardData):
	var ram_gb = card_data.ram_cost
	current_ram_gb += ram_gb
	
	ram_changed.emit()


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
		print("remove_ram_from_setup(ram_type): no index found")
	setup_changed.emit()


func remove_card_from_backpack(card_path: String):
	for i in range(backpack_items.size() - 1, -1, -1):
		if backpack_items[i]["path"] == card_path:
			backpack_items.remove_at(i)
			break
	backpack_changed.emit()


func remove_current_ram(ram_data: RamData):
	var ram_gb = ram_data.gb_size
	
	current_ram_gb -= ram_gb
	
	ram_changed.emit()



func remove_card_ram(card_data: SellCardData):
	var ram_gb = card_data.ram_cost
	
	current_ram_gb -= ram_gb
	
	ram_changed.emit()


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


func get_random_normal_enemy_data():
	var normal_enemy_list = normal_virus_types.values()
	
	return normal_enemy_list.pick_random()


func get_random_boss_enemy_data():
	var boss_enemy_list = boss_virus_types.values()
	
	return boss_enemy_list.pick_random()


func get_final_boss_enemy_data():
	var final_enemy_list = final_virus_types.values()
	
	return final_enemy_list.pick_random()



func get_random_sell_card_data():
	var sell_card_list = sell_card_types.values()
	
	return sell_card_list.pick_random()


func get_random_hardware_part_data():
	var harware_part_list = harware_part_types.values()
	
	return harware_part_list.pick_random()


func get_random_gpu_data() -> GpuData:
	var gpu_list = gpu_types.values()
	return gpu_list.pick_random()


func get_random_cpu_data() -> CpuData:
	var cpu_list = cpu_types.values()
	return cpu_list.pick_random()


func get_random_ram_data() -> RamData:
	var ram_list = harware_part_types.values()
	return ram_list.pick_random()


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


func get_total_backpack_cards()->int:
	var total_cards:int = 0
	
	for item in backpack_items:
		if item["type"] == "card":
			total_cards+=1
	return total_cards


func get_backpack_ram()->int:
	var total_ram:int = 0
	
	for item in backpack_items:
		if item["type"] == "ram":
				total_ram+=item["data"].gb_size
	return total_ram


func get_setup_ram()->int:
	var total_ram:int = 0
	
	for item in setup_ram_types:
		total_ram+=item.gb_size
		
	return total_ram


func get_total_ram()->int:
	var total_ram:int = get_setup_ram() + get_backpack_ram()
	
	return total_ram



func get_min_card_ram()->int:
	var min_ram_needed:int = 128
	
	for item in backpack_items:
		if item["type"] == "card":
			if item["data"].ram_cost < min_ram_needed:
				min_ram_needed = item["data"].ram_cost
				
	for card_type in setup_card_types:
		if card_type.ram_cost < min_ram_needed:
			min_ram_needed = card_type.ram_cost
				
	return min_ram_needed


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


func remove_backpack_card_from_backpack(card_type: SellCardData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "card" and item["data"] == card_type:
			backpack_items.remove_at(i)
			backpack_changed.emit()
			return true
	return false
	

func remove_backpack_ram_from_backpack(ram_type: RamData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "ram" and item["data"] == ram_type:
			backpack_items.remove_at(i)
			backpack_changed.emit()
			return true
	return false


func remove_backpack_gpu_from_backpack(gpu_type: GpuData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "gpu" and item["data"] == gpu_type:
			backpack_items.remove_at(i)
			backpack_changed.emit()
			return true
	return false


func remove_backpack_cpu_from_backpack(cpu_type: CpuData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "cpu" and item["data"] == cpu_type:
			backpack_items.remove_at(i)
			backpack_changed.emit()
			return true
	return false


func add_gpu_to_setup(gpu_path: String, gpu_type: GpuData):
	if setup_gpus.size() < MAX_GPU_SLOTS:
		setup_gpus.append(gpu_path)
		setup_gpu_types.append(gpu_type)
		setup_changed.emit()
		return true
	return false


func add_cpu_to_setup(cpu_path: String, cpu_type: CpuData):
	if setup_cpus.size() < MAX_CPU_SLOTS:
		setup_cpus.append(cpu_path)
		setup_cpu_types.append(cpu_type)
		setup_changed.emit()
		return true
	return false


func remove_gpu_from_setup(index: int):
	if index < 0 or index >= setup_gpu_types.size():
		print("remove_gpu_from_setup with invalid index at:  ", index)
		return
	var gpu_type = setup_gpu_types[index]
	setup_gpus.remove_at(index)
	setup_gpu_types.remove_at(index)
	add_gpu_to_backpack(BACKPACK_GPU_SCENE_PATH, gpu_type)
	setup_changed.emit()


func remove_cpu_from_setup(index: int):
	if index < 0 or index >= setup_cpu_types.size():
		print("remove_cpu_from_setup: invalid index ", index)
		return
	var cpu_type = setup_cpu_types[index]
	setup_cpus.remove_at(index)
	setup_cpu_types.remove_at(index)
	add_cpu_to_backpack(BACKPACK_CPU_SCENE_PATH, cpu_type)
	setup_changed.emit()


func move_gpu_to_setup(gpu_type: GpuData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "gpu" and item["data"] == gpu_type:
			if add_gpu_to_setup(item["path"], gpu_type):
				backpack_items.remove_at(i)
				backpack_changed.emit()
				return true
	return false


func move_cpu_to_setup(cpu_type: CpuData):
	for i in range(backpack_items.size()):
		var item = backpack_items[i]
		if item["type"] == "cpu" and item["data"] == cpu_type:
			if add_cpu_to_setup(item["path"], cpu_type):
				backpack_items.remove_at(i)
				backpack_changed.emit()
				return true
	return false


func get_gpu_stat_bonuses() -> Dictionary:
	var bonuses = { "damage": 0.0, "speed": 0.0, "health": 0.0 }
	for gpu in setup_gpu_types:
		bonuses["damage"] += gpu.damage_enhancer
		bonuses["speed"] += gpu.speed_enhancer
		bonuses["health"] += gpu.health_enhancer
	return bonuses
	
	
func get_cpu_stat_bonuses() -> Dictionary:
	var bonuses = { "damage": 0.0, "speed": 0.0, "health": 0.0 }
	for cpu in setup_cpu_types:
		bonuses["damage"] += cpu.damage_enhancer
		bonuses["speed"] += cpu.speed_enhancer
		bonuses["health"] += cpu.health_enhancer
	return bonuses


func change_player_class(new_class:String):
	PlayerClass = new_class


func can_remove_ram(ram_type: RamData) -> bool:
	
	var backpack_ram = get_backpack_ram()
	var total_ram = current_ram_gb + backpack_ram
	var ram_after_removal = total_ram - ram_type.gb_size

	var min_ram_needed = get_min_card_ram()
	
	return ram_after_removal >= min_ram_needed


func load_audio_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var master = config.get_value("audio", "master", 1.0)
		var music = config.get_value("audio", "music", 1.0)
		var sfx = config.get_value("audio", "sfx", 1.0)
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx))


# Call when player loses
func reset() -> void:
	backpack_items = []
	active_units = []
	active_commrades = []
	active_enemies = []
	player_hand_cards = []
	deck_cards = []
	setup_cards = []
	setup_card_types = []
	setup_rams = []
	setup_ram_types = []
	setup_gpus = []
	setup_gpu_types = []
	backpack_cards = []
	backpack_card_types = []
	battle_number = 1
	current_security_sweep = 1
	added_starting_card = false
	balance = 50
	PlayerClass = ""
	current_ram_gb = 0
	current_cutscene = 0
