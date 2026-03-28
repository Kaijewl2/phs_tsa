extends Control


@export var ram_stick_data: RamData


@onready var ram_stick_image: TextureRect = $ram_stick_image
@onready var equip_button: Button = $equip_button
@onready var remove_button: Button = $remove_button
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
var remove_mode:bool = false
var is_first_shake = true 
var shake_tween: Tween = null
var container_original_pos: Vector2
var insufficient_ram_container: ColorRect

var card_path: String


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
		
	if ram_stick_name == "Health RAM":
		item_info_label.text = (
			"[b]Health RAM[/b]\n\n" +
			"[font_size=24][i]" + ram_stick_desc + "[/i][/font_size]\n\n" +
			"[color=#00ff7f]+ HP[/color]      +" + str(int(health_enhancer * 100)) + "%\n" +
			"[color=#b06fd4]GB[/color]       " + str(gb_size) + "GB"
		)
	elif ram_stick_name == "Damage RAM":
		item_info_label.text = (
			"[b]Damage RAM[/b]\n\n" +
			"[font_size=24][i]" + ram_stick_desc + "[/i][/font_size]\n\n" +
			"[color=#ff4444]+ DMG[/color]    +" + str(int(damage_enhancer * 100)) + "%\n" +
			"[color=#b06fd4]GB[/color]       " + str(gb_size) + "GB"
		)
	elif ram_stick_name == "Speed RAM":
		item_info_label.text = (
			"[b]Speed RAM[/b]\n\n" +
			"[font_size=24][i]" + ram_stick_desc + "[/i][/font_size]\n\n" +
			"[color=#4fc3f7]+ SPD[/color]    +" + str(int(speed_enhancer * 100)) + "%\n" +
			"[color=#b06fd4]GB[/color]       " + str(gb_size) + "GB"
		)
	else:
		item_info_label.text = (
			"[b]Base RAM[/b]\n\n" +
			"[font_size=24][i]" + ram_stick_desc + "[/i][/font_size]\n\n" +
			"[color=#b06fd4]GB[/color]       " + str(gb_size) + "GB"
		)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if remove_mode:
			remove_from_backpack()
		else:
			add_to_setup()


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
	if GameData.can_remove_ram(ram_stick_data):
		GameData.remove_backpack_ram_from_backpack(ram_stick_data)
	else:
		# Reuse your insufficient_ram pattern
		insufficient_ram_container = get_tree().get_first_node_in_group("insufficient_ram")
		var insufficient_ram_label = insufficient_ram_container.get_node("insufficient_ram_label")
		insufficient_ram_label.add_theme_font_size_override("font_size", 54)
		insufficient_ram_label.text = "Cards need this RAM!"
		insufficient_ram_container.show()
		anim_shake(insufficient_ram_container)


func anim_shake(node):
	insufficient_ram_container.position = Vector2(757.0, 413.0)
	container_original_pos = insufficient_ram_container.position
	
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
		node.position = container_original_pos 
	
	shake_tween = create_tween()
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(-10, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(10, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(-5, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(5, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos, 0.05)
	shake_tween.tween_interval(0.5)
	shake_tween.tween_callback(node.hide)


func add_to_setup():
	GameData.ram_interacted = true
	
	if GameData.current_context == GameData.Context.NORMAL:
		if GameData.move_ram_stick_to_setup(ram_stick_data):
			print("Added ram to deck!")
			GameData.add_current_ram(ram_stick_data)
			queue_free()
		else:
			print("Deck full of ram!")
	else:
		GameData.remove_backpack_ram_from_backpack(ram_stick_data)



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
		remove_button.hide()


func _on_ram_stick_image_mouse_entered() -> void:
	item_info_container.show()
	
	if remove_mode:
		remove_button.show()
	else:
		equip_button.show()


func _on_ram_stick_image_mouse_exited() -> void:
	item_info_container.hide()
	
	if remove_mode:
		if not remove_button.is_hovered():
			remove_button.hide()
	else:
		if not equip_button.is_hovered():
			equip_button.hide()
