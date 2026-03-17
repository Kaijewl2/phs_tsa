extends Control


@export var gpu_data: GpuData


@onready var setup_gpu_image: TextureRect = $setup_gpu_image
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
	if gpu_data:
		setup_gpu_image.texture = gpu_data.gpu_image
	button.hide()


func remove_from_setup():
	# You'll need a GameData function to remove RAM from setup
	GameData.remove_gpu_from_setup(0)


func _on_remove_button_pressed() -> void:
	GameData.remove_gpu_from_setup(0)


func _on_setup_gpu_image_mouse_entered() -> void:
	button.show()


func _on_setup_gpu_image_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()


func _on_remove_button_mouse_entered() -> void:
	button.show()


func _on_remove_button_mouse_exited() -> void:
	button.hide()
