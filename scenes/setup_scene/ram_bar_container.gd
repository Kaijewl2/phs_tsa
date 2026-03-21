extends Control


@onready var ram_info_rect: ColorRect = $ram_bar/ram_info_rect
@onready var available_ram_label: Label = $ram_bar/ram_info_rect/available_ram_label
@onready var ram_info_container: ColorRect = $"../../ram_sticks_container/ram_info_container"



func _ready() -> void:
	GameData.ram_changed.connect(refresh_available_ram_text)
	refresh_available_ram_text()

func refresh_available_ram_text():
	available_ram_label.text = str(GameData.current_ram_gb) + " / " + str(GameData.MAX_RAM_GB) + " GB available"


func _on_mouse_entered() -> void:
	ram_info_rect.show()


func _on_mouse_exited() -> void:
	ram_info_rect.hide()
