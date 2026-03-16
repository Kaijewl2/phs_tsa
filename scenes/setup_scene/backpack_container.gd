extends Control

@onready var card_grid: GridContainer = $storage_img/GridContainer
const BACKPACK_CARD_SCENE = preload("res://scenes/backpack_card_scene/backpack_card.tscn")
const BACKPACK_RAM_SCENE = preload("res://scenes/backpack_ram_scene/backpack_ram.tscn")


func _ready() -> void:
	GameData.backpack_changed.connect(refresh_backpack)
	refresh_backpack()


func refresh_backpack():
	for child in card_grid.get_children():
		child.queue_free()

	for item in GameData.backpack_items:
		if item["type"] == "card":
			var backpack_card = BACKPACK_CARD_SCENE.instantiate()
			backpack_card.backpack_card_data = item["data"]
			card_grid.add_child(backpack_card)
			backpack_card.setup(item["path"])

		elif item["type"] == "ram":
			var backpack_ram = BACKPACK_RAM_SCENE.instantiate()
			backpack_ram.ram_stick_data = item["data"]
			card_grid.add_child(backpack_ram)
			backpack_ram.setup(item["path"])
			
func toggle_visibility():
	visible = !visible
