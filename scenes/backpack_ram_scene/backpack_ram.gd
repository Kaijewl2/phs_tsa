extends Control


@export var ram_stick_data: RamData


@onready var ram_stick_image: TextureRect = $ram_stick_image
@onready var button: Button = $equip_button


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
		ram_stick_name = ram_stick_data.ram_stick_name
		ram_stick_desc = ram_stick_data.ram_stick_desc
		speed_enhancer = ram_stick_data.speed_enhancer
		damage_enhancer = ram_stick_data.damage_enhancer
		health_enhancer = ram_stick_data.health_enhancer
		gb_size = ram_stick_data.gb_size
		cost = ram_stick_data.cost 


func setup(path: String):
	card_path = path
	button.pressed.connect(add_to_setup)


func add_to_setup():
	if GameData.move_ram_stick_to_setup(ram_stick_data):
		print("Added ram to deck!")
		queue_free()
	else:
		print("Deck full of ram!")


func _on_equip_button_mouse_entered() -> void:
	button.show()


func _on_equip_button_mouse_exited() -> void:
	button.hide()


func _on_ram_stick_image_mouse_entered() -> void:
	button.show()


func _on_ram_stick_image_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()
