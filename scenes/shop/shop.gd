extends Control
class_name Shop

@export var sell_card_scene: PackedScene


@onready var card_container: HBoxContainer = $card_container
@onready var hardware_container: HBoxContainer = $hardware_container


const SELL_CARD = preload("uid://cwfnhwgq5hgi7")
const RAM_STICK = preload("uid://b11vc6ohy6mxh")
const GPU_SCENE = preload("uid://nllcci5mx8v4")

func _ready() -> void:
	for i in range(4):
		var sell_card = SELL_CARD.instantiate()
		sell_card.sell_card_data = GameData.get_random_sell_card_data()
		card_container.add_child(sell_card)
		
	for i in range(4):
		var ram = RAM_STICK.instantiate()
		ram.ram_stick_data = GameData.get_random_ram_data()
		hardware_container.add_child(ram)

	for i in range(2):
		var gpu = GPU_SCENE.instantiate()
		gpu.gpu_data = GameData.get_random_gpu_data()
		hardware_container.add_child(gpu)
