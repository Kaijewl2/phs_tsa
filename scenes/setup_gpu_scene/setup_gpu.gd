extends Control


@export var gpu_data: GpuData


@onready var setup_gpu_image: TextureRect = $setup_gpu_image
@onready var button: Button = $remove_button
@onready var item_info_container: ColorRect = $item_info_container
@onready var item_info_label: RichTextLabel = $item_info_container/item_info_label


var gpu_name: String
var gpu_desc: String
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
		gpu_name = gpu_data.gpu_name
		gpu_desc = gpu_data.gpu_desc
		speed_enhancer = gpu_data.speed_enhancer
		damage_enhancer = gpu_data.damage_enhancer
		health_enhancer = gpu_data.health_enhancer
		gb_size = gpu_data.gb_size
		cost = gpu_data.cost

		if gpu_name == "Health GPU":
			item_info_label.text = (
				"[b]Health GPU[/b]\n\n" +
				"[color=#00ff7f]+ HP[/color]      +" + str(int(health_enhancer * 100)) + "%\n"
			)
		elif gpu_name == "Damage GPU":
			item_info_label.text = (
				"[b]Damage GPU[/b]\n\n" +
				"[color=#ff4444]+ DMG[/color]    +" + str(int(damage_enhancer * 100)) + "%\n"
			)
		else:
			item_info_label.text = (
				"[b]Speed GPU[/b]\n\n" +
				"[color=#4fc3f7]+ SPD[/color]    +" + str(int(speed_enhancer * 100)) + "%\n"
			)
	button.hide()


func remove_from_setup():
	GameData.remove_gpu_from_setup(0)


func _on_remove_button_pressed() -> void:
	if(GameData.backpack_items.size() + 1 <= GameData.MAX_BACKPACK_SIZE):
		GameData.remove_gpu_from_setup(0)


func _on_setup_gpu_image_mouse_entered() -> void:
	item_info_container.show()
	
	button.show()


func _on_setup_gpu_image_mouse_exited() -> void:
	item_info_container.hide()
	
	if not button.is_hovered():
		button.hide()


func _on_remove_button_mouse_entered() -> void:
	button.show()


func _on_remove_button_mouse_exited() -> void:
	button.hide()
