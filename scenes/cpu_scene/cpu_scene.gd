extends Control


signal cpu_sold(cpu_type)


@export var cpu_data: CpuData


@onready var cpu_image: TextureRect = $cpu_image
@onready var currency_label: Label = $currency_label


const CPU_PATH = "res://scenes/cpu_scene/cpu_scene.tscn"


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
		
		currency_label.text = str(cost)
		currency_label.show()


func _input(event: InputEvent) -> void:
	# Checks if input is mouse click and mouse is hovering over card
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering and event.is_pressed():
			handle_purchase()


func handle_purchase():
	# Successful purchase
	if GameData.get_balance() >= cost && GameData.backpack_cards.size() < GameData.MAX_BACKPACK_SIZE:
		GameData.change_balance(cost, "subtract")

		# Add CPU to player's backpack
		print("CPU type: ", cpu_data)
		cpu_sold.emit(cpu_data.cpu_name)
		
		GameData.add_cpu_to_backpack(CPU_PATH, cpu_data)

		# Delete card
		self.queue_free()


func _on_cpu_image_mouse_entered() -> void:
	hovering = true
	cpu_image.scale = Vector2(1.4, 1.4)


func _on_cpu_image_mouse_exited() -> void:
	hovering = false
	cpu_image.scale = Vector2(1.3, 1.3)
