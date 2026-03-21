extends Control


@export var gpu_data: GpuData


@onready var gpu_image: TextureRect = $backpack_gpu_image
@onready var equip_button: Button = $backpack_gpu_button
@onready var remove_button: Button = $remove_button


var gpu_name: String
var gpu_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false
var remove_mode:bool = false

var card_path: String


func _ready() -> void:
	if gpu_data:
		gpu_image.texture = gpu_data.gpu_image
		gpu_name = gpu_data.gpu_name
		gpu_desc = gpu_data.gpu_desc
		speed_enhancer = gpu_data.speed_enhancer
		damage_enhancer = gpu_data.damage_enhancer
		health_enhancer = gpu_data.health_enhancer
		gb_size = gpu_data.gb_size
		cost = gpu_data.cost 


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
	GameData.remove_backpack_gpu_from_backpack(gpu_data)


func add_to_setup():
	if GameData.current_context == GameData.Context.NORMAL:
		if GameData.move_gpu_to_setup(gpu_data):
			print("Added gpu to setup!")
			queue_free()
		else:
			print("Already using GPU!")
	else:
		remove_from_backpack()


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


func _on_backpack_gpu_image_mouse_entered() -> void:
	if remove_mode:
		remove_button.show()
	else:
		equip_button.show()


func _on_backpack_gpu_image_mouse_exited() -> void:
	if remove_mode:
		if not remove_button.is_hovered():
			remove_button.hide()
	else:
		if not equip_button.is_hovered():
			equip_button.hide()
