extends Control
class_name Shop

@export var sell_card_scene: PackedScene


@onready var card_container: HBoxContainer = $card_container
@onready var hardware_container: HBoxContainer = $hardware_container


const SELL_CARD = preload("uid://cwfnhwgq5hgi7")
const RAM_STICK = preload("uid://b11vc6ohy6mxh")

func _ready() -> void:
	for i in range(4):
		var sell_card = SELL_CARD.instantiate()
		sell_card.sell_card_data = GameData.get_random_sell_card_data()
		card_container.add_child(sell_card)
		
	for i in range(4):
		var hardware_part = RAM_STICK.instantiate()
		hardware_part.ram_stick_data = GameData.get_random_hardware_part_data()
		hardware_container.add_child(hardware_part)
