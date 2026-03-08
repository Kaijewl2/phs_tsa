extends Control

@onready var card_grid: GridContainer = $storage_img/GridContainer
const BACKPACK_CARD_SCENE = preload("res://scenes/backpack_card_scene/backpack_card.tscn")


func _ready() -> void:
	GameData.backpack_changed.connect(refresh_backpack)
	refresh_backpack()


func refresh_backpack():
	# Clear current cards
	for child in card_grid.get_children():
		child.queue_free()
	var temp = 0
	# Display refreshed backpack cards
	for card_path in GameData.backpack_cards:
		var backpack_card = BACKPACK_CARD_SCENE.instantiate()
		backpack_card.backpack_card_data = GameData.backpack_card_types[temp]
		card_grid.add_child(backpack_card)
		backpack_card.setup(card_path)
		temp+=1
		
func toggle_visibility():
	visible = !visible
