extends Control


@export var ram_stick_data: RamData


@onready var ram_stick_image: TextureRect = $ram_stick_image
@onready var equip_button: Button = $equip_button
@onready var remove_button: Button = $remove_button


var ram_stick_name: String
var ram_stick_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false
var remove_mode:bool = false

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


func setup(path: String, remove_mode:bool = false):
	card_path = path
	set_mode(remove_mode)


func set_mode(p_remove_mode: bool):
	remove_mode = p_remove_mode
	if equip_button.pressed.is_connected(add_to_setup):
		equip_button.pressed.disconnect(add_to_setup)
	if remove_button.pressed.is_connected(remove_from_backpack):
		remove_button.pressed.disconnect(remove_from_backpack)
		
	equip_button.hide()
	remove_button.hide()
	
	if remove_mode:
		remove_button.pressed.connect(remove_from_backpack)
	else:
		equip_button.pressed.connect(add_to_setup)


func remove_from_backpack():
	GameData.remove_backpack_ram_from_backpack(ram_stick_data)


func add_to_setup():
	if GameData.current_context == GameData.Context.NORMAL:
		if GameData.move_ram_stick_to_setup(ram_stick_data):
			print("Added ram to deck!")
			GameData.add_current_ram(ram_stick_data)
			queue_free()
		else:
			print("Deck full of ram!")
	else:
		GameData.remove_backpack_ram_from_backpack(ram_stick_data)



func _on_equip_button_mouse_entered() -> void:
	if not remove_button.visible:
		equip_button.show()


func _on_equip_button_mouse_exited() -> void:
	if not equip_button.is_hovered():
		equip_button.hide()


func _on_remove_button_mouse_entered() -> void:
	if not equip_button.visible:
		remove_button.show()


func _on_remove_button_mouse_exited() -> void:
	if not remove_button.is_hovered():
		remove_button.show()


func _on_ram_stick_image_mouse_entered() -> void:
	if remove_mode:
		remove_button.show()
	else:
		equip_button.show()


func _on_ram_stick_image_mouse_exited() -> void:
	if remove_mode:
		if not remove_button.is_hovered():
			remove_button.hide()
	else:
		if not equip_button.is_hovered():
			equip_button.hide()
