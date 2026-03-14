extends Control


@export var ram_stick_data: RamData


var ram_stick_image: Texture2D
var ram_stick_name: String
var ram_stick_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int


func _ready() -> void:
	if ram_stick_data:
		ram_stick_image = ram_stick_data.ram_stick_image
		ram_stick_name = ram_stick_data.ram_stick_name
		ram_stick_desc = ram_stick_data.ram_stick_desc
		speed_enhancer = ram_stick_data.speed_enhancer
		damage_enhancer = ram_stick_data.damage_enhancer
		health_enhancer = ram_stick_data.health_enhancer
		gb_size = ram_stick_data.gb_size
		cost = ram_stick_data.cost
