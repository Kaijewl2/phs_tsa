extends Control
class_name SellCard


signal card_sold(card_type)


@export var sell_card_data: SellCardData


@onready var card_borders: Control = $card_img/card_borders
@onready var card_frame: TextureRect = $card_img
@onready var card_background: ColorRect = $card_img/card_background
@onready var card_icon: TextureRect = $card_img/card_icon
@onready var player_hand = get_tree().get_first_node_in_group("player_hand")
@onready var price_label: Label = $price_label
@onready var card_desc: Label = $card_img/card_desc
@onready var card_name: Label = $card_img/card_name
@onready var item_info_container: ColorRect = $item_info_container
@onready var item_info_label: RichTextLabel = $item_info_container/item_info_label


const SELL_CARD_PATH: String = "res://scenes/shop/sell_card_scene/sell_card.tscn"
const SETUP_CARD_PATH: String = "res://scenes/setup_card_scene/setup_card.tscn"
const WALKING_BOT_CARD_SCENE_PATH: String = "res://scenes/card_scenes/card_scene/card.tscn"


# Used for hover info
var unit_name: String
var health: float
var damage: int
var speed: int
var ram_cost: int
var value: int
var hovering: bool
var press_count: int
var coin_counter_original_pos: Vector2
var is_first_shake = true 
var shake_tween: Tween = null
var card_frame_scale: Vector2


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
		card_desc.text = sell_card_data.sell_card_desc
		card_name.text = sell_card_data.sell_card_name
		ram_cost = sell_card_data.ram_cost
	
	price_label.text = str(value)
	
	item_info_label.text = (
		"[b]" + sell_card_data.sell_card_name + "[/b]\n\n" +
		"[font_size=20][i]" + sell_card_data.sell_card_desc + "[/i][/font_size]\n\n" +
		"[color=#00ff7f]HP[/color]      " + str(int(health)) + "\n" +
		"[color=#ff4444]DMG[/color]    " + str(damage) + "\n" +
		"[color=#4fc3f7]SPD[/color]    " + str(speed) + "\n" +
		"[color=#b06fd4]RAM[/color]    " + str(ram_cost) + "GB"
	)

	card_frame_scale = card_frame.scale


func _input(event: InputEvent) -> void:
	# Checks if input is mouse click and mouse is hovering over card
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if hovering and event.is_pressed():
			handle_purchase()


func anim_shake(node):
	if is_first_shake:
		coin_counter_original_pos = node.position
		is_first_shake = false
	
	# Kill previous tween
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	
	# Always shake from the saved original position
	shake_tween = create_tween()
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(-10, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(10, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(-5, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos + Vector2(5, 0), 0.05)
	shake_tween.tween_property(node, "position", coin_counter_original_pos, 0.05)
	
	press_count+=1

func handle_purchase():
	# Successful purchase
	if GameData.get_balance() >= value && GameData.backpack_items.size() < GameData.MAX_BACKPACK_SIZE:
		GameData.change_balance(value, "subtract")

		# Add card to player's backpack
		card_sold.emit(sell_card_data.sell_card_name)
		GameData.add_card_to_backpack(SETUP_CARD_PATH, sell_card_data)

		# Delete card
		self.queue_free()
	# Insufficient funds
	else:
		var coin_counter: Control = get_parent().get_parent().get_node("coin_counter")
		coin_counter.get_node("AnimationPlayer").play("insufficient_funds")
		anim_shake(coin_counter)

		if press_count >= 10:
			var brick: Control = get_parent().get_parent().get_node("brick")
			brick.show()
			await get_tree().create_timer(2.0).timeout
			brick.hide()

			press_count = 0


func _on_card_img_mouse_entered() -> void:
	item_info_container.show()
	hovering = true
	card_frame.scale = Vector2(card_frame_scale.x + 0.15, card_frame_scale.y + 0.15)


func _on_card_img_mouse_exited() -> void:
	item_info_container.hide()
	hovering = false
	card_frame.scale = card_frame_scale
