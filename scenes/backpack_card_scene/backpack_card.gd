extends Control


@export var backpack_card_data: SellCardData


@onready var card_frame: TextureRect = $card_frame
@onready var card_background: ColorRect = $card_frame/card_background
@onready var card_image: TextureRect = $card_frame/card_image
@onready var card_name: Label = $card_name
@onready var card_desc: Label = $card_desc
@onready var card_borders: Control = $card_frame/card_borders

@onready var equip_button: Button = $equip_button
@onready var remove_button: Button = $remove_button
@onready var item_info_container: ColorRect = $item_info_container
@onready var item_info_label: RichTextLabel = $item_info_container/item_info_label


var health: float = 6.7
var damage: int = 67
var speed: int = 67
var value: int = 76
var ram_cost: int
var is_first_shake = true 
var shake_tween: Tween = null
var container_original_pos: Vector2
var insufficient_ram_container: ColorRect
var remove_mode:bool = false

var card_path: String


func _ready() -> void:
	if backpack_card_data:
		card_borders.modulate = backpack_card_data.card_borders
		card_frame.texture = backpack_card_data.card_frame
		card_background.color = backpack_card_data.card_background
		card_image.texture = backpack_card_data.card_icon
		card_name.text = backpack_card_data.sell_card_name
		card_desc.text = backpack_card_data.sell_card_desc
		health = backpack_card_data.health
		damage = backpack_card_data.damage
		speed = backpack_card_data.speed
		value = backpack_card_data.value
		ram_cost = backpack_card_data.ram_cost


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if remove_mode:
			remove_from_backpack()
		else:
			add_to_setup()


	item_info_label.text = (
		"[b]" + backpack_card_data.sell_card_name + "[/b]\n\n" +
		"[font_size=20][i]" + backpack_card_data.sell_card_desc + "[/i][/font_size]\n\n" +
		"[color=#00ff7f]HP[/color]      " + str(int(health)) + "\n" +
		"[color=#ff4444]DMG[/color]    " + str(damage) + "\n" +
		"[color=#4fc3f7]SPD[/color]    " + str(speed) + "\n" +
		"[color=#b06fd4]RAM[/color]    " + str(ram_cost) + "GB"
	)
	
	await get_tree().process_frame
	await  get_tree().process_frame
	insufficient_ram_container = get_tree().get_first_node_in_group("insufficient_ram")
	insufficient_ram_container.position = Vector2(757.0, 413.0)
	container_original_pos = insufficient_ram_container.position


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
	var total_cards:int = GameData.active_units.size() + GameData.get_total_backpack_cards()

	if total_cards <= 1:
		insufficient_ram_container = get_tree().get_first_node_in_group("insufficient_ram")
		var insufficient_ram_label = insufficient_ram_container.get_node("insufficient_ram_label")
		insufficient_ram_label.add_theme_font_size_override("font_size", 54)
		insufficient_ram_label.text = "Need at least 1 card!"
		insufficient_ram_container.show()
		anim_shake(insufficient_ram_container)
	else:
		GameData.remove_backpack_card_from_backpack(backpack_card_data)


func add_to_setup():
	# Add allow card be added if sufficient RAM and not at max cards
	if GameData.current_context == GameData.Context.NORMAL:
		if((GameData.current_ram_gb - ram_cost) >= 0) and GameData.setup_cards.size() < GameData.MAX_SETUP_SIZE:
			GameData.remove_card_ram(backpack_card_data)
			if GameData.move_backpack_card_to_setup(backpack_card_data):
				print("Added to deck!")
				
				queue_free()
			else:
				print("Deck full!")
		elif GameData.setup_cards.size() >= GameData.MAX_SETUP_SIZE:
			insufficient_ram_container.show()
			insufficient_ram_container.get_node("insufficient_ram_label").text = "Hand full!"
			anim_shake(insufficient_ram_container)
		else:
			insufficient_ram_container.show()
			insufficient_ram_container.get_node("insufficient_ram_label").text = "Not enough RAM!"
			anim_shake(insufficient_ram_container)
	else:
		GameData.remove_backpack_card_from_backpack(backpack_card_data)


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


func _on_texture_rect_mouse_entered() -> void:
	item_info_container.show()
	
	if remove_mode:
		remove_button.show()
	else:
		equip_button.show()


func _on_texture_rect_mouse_exited() -> void:
	item_info_container.hide()
	
	if remove_mode:
		if not remove_button.is_hovered():
			remove_button.hide()
	else:
		if not equip_button.is_hovered():
			equip_button.hide()
