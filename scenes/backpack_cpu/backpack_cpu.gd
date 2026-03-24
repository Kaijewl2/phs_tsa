extends Control


@export var cpu_data: CpuData


@onready var cpu_image: TextureRect = $backpack_cpu_image
@onready var equip_button: Button = $backpack_cpu_button
@onready var remove_button: Button = $remove_button
@onready var item_info_container: ColorRect = $item_info_container
@onready var item_info_label: RichTextLabel = $item_info_container/item_info_label


var cpu_name: String
var cpu_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false
var remove_mode:bool = false

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
		
		if cpu_name == "Health CPU":
			item_info_label.text = (
			"[b]Health CPU[/b]\n\n" +
			"[font_size=20][i]" + cpu_desc + "[/i][/font_size]\n\n" +
			"[color=#00ff7f]+ HP[/color]      +" + str(int(health_enhancer * 100)) + "%\n"
			)
		elif cpu_name == "Damage CPU":
			item_info_label.text = (
				"[b]Damage CPU[/b]\n\n" +
				"[font_size=20][i]" + cpu_desc + "[/i][/font_size]\n\n" +
				"[color=#ff4444]+ DMG[/color]    +" + str(int(damage_enhancer * 100)) + "%\n"
			)
		else:
			item_info_label.text = (
				"[b]Speed CPU[/b]\n\n" +
				"[font_size=20][i]" + cpu_desc + "[/i][/font_size]\n\n" +
				"[color=#4fc3f7]+ SPD[/color]    +" + str(int(speed_enhancer * 100)) + "%\n"
			)
func setup(path: String, remove_mode:bool = false):
	card_path = path
	set_mode(remove_mode)


func set_mode(p_remove_mode: bool):
	remove_mode = p_remove_mode
	if equip_button.pressed.is_connected(add_to_setup):
		equip_button.pressed.disconnect(add_to_setup)
	if remove_button.pressed.is_connected(remove_from_backpack):
		remove_button.pressed.disconnect(remove_from_backpack)
		
	equip_button.hide()
	remove_button.hide()
	
	if remove_mode:
		remove_button.pressed.connect(remove_from_backpack)
	else:
		equip_button.pressed.connect(add_to_setup)


func remove_from_backpack():
	GameData.remove_backpack_cpu_from_backpack(cpu_data)


func add_to_setup():
	if GameData.current_context == GameData.Context.NORMAL:
		if GameData.move_cpu_to_setup(cpu_data):
			print("Added cpu to setup!")
			queue_free()
		else:
			print("Already using CPU!")
	else:
		remove_from_backpack()


func _on_equip_button_mouse_entered() -> void:
	if not remove_button.visible:
		equip_button.show()


func _on_equip_button_mouse_exited() -> void:
	if not equip_button.is_hovered():
		equip_button.hide()


func _on_remove_button_mouse_entered() -> void:
	if not equip_button.visible:
		remove_button.show()


func _on_remove_button_mouse_exited() -> void:
	if not remove_button.is_hovered():
		remove_button.show()


func _on_backpack_cpu_image_mouse_entered() -> void:
	item_info_container.show()
	
	if remove_mode:
		remove_button.show()
	else:
		equip_button.show()


func _on_backpack_cpu_image_mouse_exited() -> void:
	item_info_container.hide()
	
	if remove_mode:
		if not remove_button.is_hovered():
			remove_button.hide()
	else:
		if not equip_button.is_hovered():
			equip_button.hide()
