extends Control
class_name Shop

@export var sell_card_scene: PackedScene


@onready var card_container: HBoxContainer = $card_container
@onready var hardware_container: HBoxContainer = $hardware_container
@onready var brick_hover_container: ColorRect = $brick/brick_hover_container
@onready var storage_bar: ProgressBar = $storage_bar
@onready var ram_bar: ProgressBar = $ram_bar
@onready var storage_info_container: ColorRect = $storage_bar/storage_info_container


const SELL_CARD = preload("uid://cwfnhwgq5hgi7")
const RAM_STICK = preload("uid://b11vc6ohy6mxh")
const GPU_SCENE = preload("uid://nllcci5mx8v4")
const CPU_SCENE = preload("uid://bwbxpnl8s8apm")
const HARDWARE_ITEMS_AVAILABLE: int = 4


var harware_types = [RAM_STICK, GPU_SCENE, CPU_SCENE]


func _ready() -> void:
	storage_bar.max_value = GameData.MAX_BACKPACK_SIZE
	storage_bar.value = GameData.backpack_items.size()
	storage_info_container.get_node("storage_info_label").text = str(int(storage_bar.value)) + " / " + str(int(storage_bar.max_value))
	GameData.backpack_changed.connect(update_storage_bar)
	
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


func update_storage_bar():
	storage_bar.value = GameData.backpack_items.size()
	storage_info_container.get_node("storage_info_label").text = str(int(storage_bar.value)) + " / " + str(int(storage_bar.max_value))


func _on_brick_img_mouse_entered() -> void:
	brick_hover_container.show()


func _on_brick_img_mouse_exited() -> void:
	brick_hover_container.hide()


func _on_storage_bar_mouse_entered() -> void:
	storage_info_container.show()


func _on_storage_bar_mouse_exited() -> void:
	storage_info_container.hide()
