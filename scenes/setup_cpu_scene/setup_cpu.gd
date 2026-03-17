extends Control


@export var cpu_data: CpuData


@onready var setup_cpu_image: TextureRect = $setup_cpu_image
@onready var button: Button = $remove_button


var ram_stick_name: String
var ram_stick_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false
var slot_index = 0

var card_path: String


func _ready() -> void:
	if cpu_data:
		setup_cpu_image.texture = cpu_data.cpu_image
	button.hide()


func remove_from_setup():
	GameData.remove_cpu_from_setup(0)


func _on_remove_button_pressed() -> void:
	GameData.remove_cpu_from_setup(0)


func _on_setup_gpu_image_mouse_entered() -> void:
	button.show()


func _on_setup_gpu_image_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()


func _on_remove_button_mouse_entered() -> void:
	button.show()


func _on_remove_button_mouse_exited() -> void:
	button.hide()


func _on_setup_cpu_image_mouse_entered() -> void:
	pass # Replace with function body.


func _on_setup_cpu_image_mouse_exited() -> void:
	pass # Replace with function body.
