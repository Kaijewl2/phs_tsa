extends Control


@export var sell_card_data: SellCardData


const SELF_PATH = "res://scenes/setup_card_scene/setup_card.tscn"


@onready var button: Button = $Button
@onready var card_borders: Control = $card_frame/card_borders
@onready var card_frame: TextureRect = $card_frame
@onready var card_background: ColorRect = $card_frame/card_background
@onready var card_icon: TextureRect = $card_frame/card_icon
@onready var card_name: Label = $card_name
@onready var card_desc: Label = $card_desc
@onready var item_info_container: ColorRect = $item_info_container
@onready var item_info_label: RichTextLabel = $item_info_container/item_info_label


var card_path: String
var unit_name: String
var health: float
var damage: int
var speed: int
var value: int
var ram_cost: int
var hovering: bool


func _ready() -> void:
	if sell_card_data:
		card_frame.texture = sell_card_data.card_frame
		card_borders.modulate = sell_card_data.card_borders
		card_background.color = sell_card_data.card_background
		card_icon.texture = sell_card_data.card_icon
		unit_name = sell_card_data.sell_card_name
		health = sell_card_data.health
		damage = sell_card_data.damage
		speed = sell_card_data.speed
		value = sell_card_data.value
		ram_cost = sell_card_data.ram_cost
		card_desc.text = sell_card_data.sell_card_desc
		card_name.text = sell_card_data.sell_card_name
		
	item_info_label.text = (
		"[b]" + sell_card_data.sell_card_name + "[/b]\n\n" +
		"[font_size=20][i]" + sell_card_data.sell_card_desc + "[/i][/font_size]\n\n" +
		"[color=#00ff7f]HP[/color]      " + str(int(health)) + "\n" +
		"[color=#ff4444]DMG[/color]    " + str(damage) + "\n" +
		"[color=#4fc3f7]SPD[/color]    " + str(speed) + "\n" +
		"[color=#b06fd4]RAM[/color]    " + str(ram_cost) + "GB"
	)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameData.backpack_items.size() + 1 <= GameData.MAX_BACKPACK_SIZE:
			GameData.remove_card_from_setup(sell_card_data)
			GameData.add_card_ram(sell_card_data)
			GameData.add_card_to_backpack(SELF_PATH, sell_card_data)


func setup(path: String):
	card_path = path


func _on_mouse_entered() -> void:
	pass


func _on_mouse_exited() -> void:
	pass


func _on_button_mouse_entered() -> void:
	button.show()


func _on_button_mouse_exited() -> void:
	button.hide()


func _on_button_pressed() -> void:
	if(GameData.backpack_items.size() + 1 <= GameData.MAX_BACKPACK_SIZE):
		GameData.remove_card_from_setup(sell_card_data)
		GameData.add_card_ram(sell_card_data)
		GameData.add_card_to_backpack(SELF_PATH, sell_card_data)


func _on_texture_rect_mouse_entered() -> void:
	item_info_container.show()
	button.show()


func _on_texture_rect_mouse_exited() -> void:
	item_info_container.hide()
	
	if not button.is_hovered():
		button.hide()
