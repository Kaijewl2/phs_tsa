extends Control


var card_path: String


@onready var texture_rect: TextureRect = $TextureRect
@onready var button: Button = $Button


func setup(path: String):
	card_path = path
	button.pressed.connect(add_to_deck)
	
func add_to_deck():
	if GameData.add_card_to_deck(card_path):
		print("Added to deck!")
	else:
		print("Deck full!")
