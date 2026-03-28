extends Control
class_name Shop

@export var sell_card_scene: PackedScene


@onready var card_container: HBoxContainer = $card_container
@onready var hardware_container: HBoxContainer = $hardware_container
@onready var brick_hover_container: ColorRect = $brick/brick_hover_container
@onready var storage_bar: ProgressBar = $storage_bar
@onready var ram_bar: ProgressBar = $ram_bar
@onready var storage_info_container: ColorRect = $storage_bar/storage_info_container
@onready var ram_info_container: ColorRect = $ram_bar/ram_info_container
@onready var ram_info_label: Label = $ram_bar/ram_info_container/ram_info_label
@onready var brick_label: Label = $brick/brick_hover_container/Label


const SELL_CARD = preload("uid://cwfnhwgq5hgi7")
const RAM_STICK = preload("uid://b11vc6ohy6mxh")
const GPU_SCENE = preload("uid://nllcci5mx8v4")
const CPU_SCENE = preload("uid://bwbxpnl8s8apm")
const HARDWARE_ITEMS_AVAILABLE: int = 4


var harware_types = [RAM_STICK, GPU_SCENE, CPU_SCENE]

var brick_messages = [
	"Don't touch anything you can't afford",
	"Back already?",
	"My shop. My rules. Buy or leave",
	"I've seen better setups on a potato",
	"The viruses aren't going to delete themselves",
	"You're still here?",
	"Last fella who ignored my RAM advice didn't make it",
	"GPU's fresh in. Don't ask where I got it",
	"I don't do refunds",
	"Spend wisely. You won't get another chance",
	"Those viruses aren't going to delete themselves",
	"I've sold to worse. Barely.",
	"Don't make me regret lending you that starter card",
	"My prices are fair. My patience is not",
	"You look like a RAM stick kind of person. Buy one",
	"Do you have any catnip?",
	"Where did these viruses come from anyway?",
	"That setup? Bold",
	"RAM first. Always RAM. Trust me",
	"I can smell bad builds from here",
	"More cards won't help if you can't run them",
	"I had a guy like you once. Had...",
	"That CPU? It works... probably",
	"You planning ahead or just guessing?",
	"I hope you know what you're doing. I don't",
	"You call that optimized?",
	"You're gonna bottleneck yourself. I can feel it",
	"Arch BTW",
	"I've seen worse builds. Not many, though",
	"That GPU? Hot. Literally. Might explode",
	"You're stacking stats with no plan. I respect the chaos",
	"You look like the type to ignore warnings",
	"You might need extra thermal paste for some of these CPUs",
	"More RAM, fewer regrets",
	"Speed's nice. Stability's nicer",
	"You got coin? I got harware",
	"I don't sell miracles. Just upgrades",
	"You want power? Pay for it",
	"That purchase? Questionable",
	"You're not ready for what's ahead",
	"Better players would've left by now",
	"I shouldn't be helping you this much",
	"You look like you just lost a run",
	"You're playing checkers in a chess run",
	"What does GNU even stand for",
	"I've seen that strategy fail before",
	"Keep going. I need customers to come back",
	"You look like you need direction. I just sell stuff",
	"You'll learn... probably",
]

func _ready() -> void:
	storage_bar.max_value = GameData.MAX_BACKPACK_SIZE
	storage_bar.value = GameData.backpack_items.size()
	storage_info_container.get_node("storage_info_label").text = str(int(GameData.MAX_BACKPACK_SIZE - (GameData.backpack_items.size()))) + " / " + str(int(GameData.MAX_BACKPACK_SIZE)) + " available backpack slots"
	GameData.backpack_changed.connect(update_storage_bar)
	
	ram_bar.max_value = GameData.MAX_RAM_GB
	GameData.backpack_changed.connect(update_ram_bar)
	update_ram_bar()
	
	for i in range(HARDWARE_ITEMS_AVAILABLE):
		var random_hardware_type = harware_types.pick_random()
		
		if(random_hardware_type == RAM_STICK):
			var ram = RAM_STICK.instantiate()
			ram.ram_stick_data = GameData.get_random_ram_data()
			hardware_container.add_child(ram)
		elif(random_hardware_type == CPU_SCENE):
			var cpu = CPU_SCENE.instantiate()
			cpu.cpu_data = GameData.get_random_cpu_data()
			hardware_container.add_child(cpu)
		elif(random_hardware_type == GPU_SCENE):
			var gpu = GPU_SCENE.instantiate()
			gpu.gpu_data = GameData.get_random_gpu_data()
			hardware_container.add_child(gpu)
		else:
			print("Err")

	for i in range(4):
		var sell_card = SELL_CARD.instantiate()
		sell_card.sell_card_data = GameData.get_random_sell_card_data()
		card_container.add_child(sell_card)


func update_ram_bar():
	var backpack_ram = GameData.get_backpack_ram()
	var current_ram = GameData.current_ram_gb
	var available_ram = current_ram + backpack_ram
	ram_bar.max_value = GameData.MAX_RAM_GB
	ram_bar.value = available_ram
	ram_info_label.text = str(available_ram) + " GB available"


func update_storage_bar():
	storage_bar.value = GameData.backpack_items.size()
	storage_info_container.get_node("storage_info_label").text = str(int(GameData.MAX_BACKPACK_SIZE - (GameData.backpack_items.size()))) + " / " + str(int(GameData.MAX_BACKPACK_SIZE)) + " available backpack slots"


func random_brick_label() -> String:
	return brick_messages.pick_random()


func _on_brick_img_mouse_entered() -> void:
	brick_label.text = random_brick_label()
	brick_hover_container.show()


func _on_brick_img_mouse_exited() -> void:
	brick_hover_container.hide()


func _on_storage_bar_mouse_entered() -> void:
	storage_info_container.show()


func _on_storage_bar_mouse_exited() -> void:
	storage_info_container.show()


func _on_ram_bar_mouse_entered() -> void:
	ram_info_container.show()


func _on_ram_bar_mouse_exited() -> void:
	ram_info_container.show()
