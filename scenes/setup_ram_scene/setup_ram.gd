extends Control


@export var ram_stick_data: RamData


@onready var ram_stick_image: TextureRect = $ram_stick_image
@onready var button: Button = $remove_button


var ram_stick_name: String
var ram_stick_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false

var card_path: String


func _ready() -> void:
	if ram_stick_data:
		ram_stick_image.texture = ram_stick_data.ram_stick_image
	button.hide()


func remove_from_setup():
	# You'll need a GameData function to remove RAM from setup
	GameData.remove_ram_from_setup(ram_stick_data)


func _on_equip_button_mouse_entered() -> void:
	button.show()


func _on_equip_button_mouse_exited() -> void:
	button.hide()


func _on_ram_stick_image_mouse_entered() -> void:
	button.show()


func _on_ram_stick_image_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()


func _on_remove_button_pressed() -> void:
	GameData.remove_ram_from_setup(ram_stick_data)
