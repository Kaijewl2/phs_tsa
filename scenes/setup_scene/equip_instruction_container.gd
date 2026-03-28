extends Control


func _ready() -> void:
	GameData.ram_changed.connect(check_if_needed)
	check_if_needed()


func check_if_needed():
	if GameData.ram_interacted:
		hide()
