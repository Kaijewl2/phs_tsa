extends Control


@export var cpu_data: CpuData


@onready var cpu_image: TextureRect = $backpack_cpu_image
@onready var button: Button = $backpack_cpu_button


var cpu_name: String
var cpu_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false

var card_path: String


func _ready() -> void:
	if cpu_data:
		cpu_image.texture = cpu_data.cpu_image
		cpu_name = cpu_data.cpu_name
		cpu_desc = cpu_data.cpu_desc
		speed_enhancer = cpu_data.speed_enhancer
		damage_enhancer = cpu_data.damage_enhancer
		health_enhancer = cpu_data.health_enhancer
		gb_size = cpu_data.gb_size
		cost = cpu_data.cost 


func setup(path: String):
	card_path = path
	button.pressed.connect(add_to_setup)


func add_to_setup():
	if GameData.move_cpu_to_setup(cpu_data):
		print("Added cpu to setup!")
		queue_free()
	else:
		print("Already using CPU!")


func _on_backpack_cpu_image_mouse_entered() -> void:
	button.show()


func _on_backpack_cpu_image_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()


func _on_backpack_cpu_button_mouse_entered() -> void:
	button.show()


func _on_backpack_cpu_button_mouse_exited() -> void:
	button.hide()
