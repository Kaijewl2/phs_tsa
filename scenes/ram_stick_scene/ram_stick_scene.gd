extends Control


signal ram_sold(ram_type)


@export var ram_stick_data: RamData


@onready var ram_stick_image: TextureRect = $ram_stick_image
@onready var currency_label: Label = $currency_label


const RAM_STICK_PATH = "res://scenes/ram_stick_scene/ram_stick_scene.tscn"


var ram_stick_name: String
var ram_stick_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false


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

		# Add RAM to player's backpack
		ram_sold.emit(ram_stick_data.ram_stick_name)
		
		GameData.add_ram_stick_to_backpack(RAM_STICK_PATH, ram_stick_data)

		# Delete card
		self.queue_free()


func _on_ram_stick_image_mouse_entered() -> void:
	hovering = true
	ram_stick_image.scale = Vector2(1.05, 1.05)


func _on_ram_stick_image_mouse_exited() -> void:
	hovering = false
	ram_stick_image.scale = Vector2(1.0, 1.0)
