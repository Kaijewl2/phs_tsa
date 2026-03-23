extends Control


@export var cpu_data: CpuData


@onready var setup_cpu_image: TextureRect = $setup_cpu_image
@onready var button: Button = $remove_button
@onready var item_info_container: ColorRect = $item_info_container
@onready var item_info_label: RichTextLabel = $item_info_container/item_info_label


var ram_stick_name: String
var ram_stick_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false
var cpu_name: String
var cpu_desc: String
var slot_index = 0

var card_path: String


func _ready() -> void:
	if cpu_data:
		setup_cpu_image.texture = cpu_data.cpu_image
		cpu_name = cpu_data.cpu_name
		cpu_desc = cpu_data.cpu_desc
		speed_enhancer = cpu_data.speed_enhancer
		damage_enhancer = cpu_data.damage_enhancer
		health_enhancer = cpu_data.health_enhancer
		gb_size = cpu_data.gb_size
		cost = cpu_data.cost 
		
		if cpu_name == "Health CPU":
			item_info_label.text = (
			"[b]Health CPU[/b]\n\n" +
			"[color=#00ff7f]+ HP[/color]      +" + str(int(health_enhancer * 100)) + "%\n"
			)
		elif cpu_name == "Damage CPU":
			item_info_label.text = (
				"[b]Damage CPU[/b]\n\n" +
				"[color=#ff4444]+ DMG[/color]    +" + str(int(damage_enhancer * 100)) + "%\n"
			)
		else:
			item_info_label.text = (
				"[b]Speed CPU[/b]\n\n" +
				"[color=#4fc3f7]+ SPD[/color]    +" + str(int(speed_enhancer * 100)) + "%\n"
			)
	button.hide()


func remove_from_setup():
	GameData.remove_cpu_from_setup(0)


func _on_remove_button_pressed() -> void:
	if(GameData.backpack_items.size() + 1 <= GameData.MAX_BACKPACK_SIZE):
		GameData.remove_cpu_from_setup(0)


func _on_remove_button_mouse_entered() -> void:
	button.show()


func _on_remove_button_mouse_exited() -> void:
	button.hide()


func _on_setup_cpu_image_mouse_entered() -> void:
	item_info_container.show()
	button.show()


func _on_setup_cpu_image_mouse_exited() -> void:
	item_info_container.hide()
	
	if not button.is_hovered():
		button.hide()
