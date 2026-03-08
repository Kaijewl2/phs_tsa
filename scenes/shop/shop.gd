extends Control
class_name Shop

@export var sell_card_scene: PackedScene
@export var card_container: HBoxContainer
const SELL_CARD = preload("uid://cwfnhwgq5hgi7")

func _ready() -> void:
	for i in range(4):
		var sell_card = SELL_CARD.instantiate()
		sell_card.sell_card_data = GameData.get_random_sell_card_data()
		card_container.add_child(sell_card)
