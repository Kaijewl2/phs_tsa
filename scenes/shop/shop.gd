extends Control
class_name Shop

@export var sell_card_scene: PackedScene


@onready var card_container: HBoxContainer = $card_container
@onready var hardware_container: HBoxContainer = $hardware_container


const SELL_CARD = preload("uid://cwfnhwgq5hgi7")
const RAM_STICK = preload("uid://b11vc6ohy6mxh")
const GPU_SCENE = preload("uid://nllcci5mx8v4")
const CPU_SCENE = preload("uid://bwbxpnl8s8apm")
const HARDWARE_ITEMS_AVAILABLE: int = 4


var harware_types = [RAM_STICK, GPU_SCENE, CPU_SCENE]


func _ready() -> void:
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
			print("Shi won't work")

	for i in range(4):
		var sell_card = SELL_CARD.instantiate()
		sell_card.sell_card_data = GameData.get_random_sell_card_data()
		card_container.add_child(sell_card)
