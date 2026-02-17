extends Control
class_name Shop

@export var sell_card_scene: PackedScene
@export var card_container: HBoxContainer

func _ready() -> void:
	for i in range(4):
		var sell_card = sell_card_scene.instantiate()
		card_container.add_child(sell_card)
