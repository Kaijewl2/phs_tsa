extends Control


signal gpu_sold(gpu_type)


@export var gpu_data: GpuData


@onready var gpu_image: TextureRect = $gpu_image
@onready var currency_label: Label = $currency_label


const GPU_PATH = "res://scenes/gpu_scene/gpu_scene.tscn"


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
		
		currency_label.text = str(cost)
		currency_label.show()


func _input(event: InputEvent) -> void:
	# Checks if input is mouse click and mouse is hovering over card
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering and event.is_pressed():
			handle_purchase()


func handle_purchase():
	# Successful purchase
	if GameData.get_balance() >= cost && GameData.backpack_items.size() < GameData.MAX_BACKPACK_SIZE:
		GameData.change_balance(cost, "subtract")

		# Add GPU to player's backpack
		print("GPU type: ", gpu_data)
		gpu_sold.emit(gpu_data.gpu_name)
		
		GameData.add_gpu_to_backpack(GPU_PATH, gpu_data)

		# Delete card
		self.queue_free()


func _on_gpu_image_mouse_entered() -> void:
	hovering = true
	gpu_image.scale = Vector2(0.4, 0.4)


func _on_gpu_image_mouse_exited() -> void:
	hovering = false
	gpu_image.scale = Vector2(0.37, 0.37)
