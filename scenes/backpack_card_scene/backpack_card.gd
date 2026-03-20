extends Control


@export var backpack_card_data: SellCardData


@onready var card_frame: TextureRect = $card_frame
@onready var card_background: ColorRect = $card_frame/card_background
@onready var card_image: TextureRect = $card_frame/card_image
@onready var card_name: Label = $card_name
@onready var card_desc: Label = $card_desc
@onready var card_borders: Control = $card_frame/card_borders

@onready var button: Button = $Button


var health: float = 6.7
var damage: int = 67
var speed: int = 67
var value: int = 76
var ram_cost: int
var is_first_shake = true 
var shake_tween: Tween = null
var container_original_pos: Vector2
var insufficient_ram_container: ColorRect

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
	
	
	await get_tree().process_frame
	await  get_tree().process_frame
	insufficient_ram_container = get_tree().get_first_node_in_group("insufficient_ram")
	insufficient_ram_container.position = Vector2(757.0, 413.0)
	container_original_pos = insufficient_ram_container.position


func setup(path: String):
	card_path = path
	button.pressed.connect(add_to_setup)

	
func add_to_setup():
	# Add allow card be added if sufficient RAM and not at max cards
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


func _on_button_mouse_entered() -> void:
	button.show()


func _on_button_mouse_exited() -> void:
	button.hide()


func _on_texture_rect_mouse_entered() -> void:
	button.show()


func _on_texture_rect_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()
