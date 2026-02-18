extends Control


@onready var label: Label = $Label


func _ready() -> void:
	label.text = str(GameData.get_balance())
	
	GameData.balance_changed.connect(update_balance_display)

func update_balance_display(new_balance):
	label.text = str(new_balance)
