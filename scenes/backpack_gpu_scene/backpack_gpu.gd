extends Control


@export var gpu_data: GpuData


@onready var gpu_image: TextureRect = $backpack_gpu_image
@onready var button: Button = $backpack_gpu_button


var gpu_name: String
var gpu_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false

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


func setup(path: String):
	card_path = path
	button.pressed.connect(add_to_setup)


func add_to_setup():
	if GameData.move_gpu_to_setup(gpu_data):
		print("Added gpu to setup!")
		queue_free()
	else:
		print("Already using GPU!")


func _on_backpack_gpu_image_mouse_entered() -> void:
	button.show()


func _on_backpack_gpu_image_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()


func _on_backpack_gpu_button_mouse_entered() -> void:
	button.show()


func _on_backpack_gpu_button_mouse_exited() -> void:
	button.hide()
