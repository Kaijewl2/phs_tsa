extends Control


@export var ram_stick_data: RamData


@onready var ram_stick_image: TextureRect = $ram_stick_image
@onready var button: Button = $remove_button


var ram_stick_name: String
var ram_stick_desc: String
var speed_enhancer: float
var damage_enhancer: float
var health_enhancer: float
var gb_size: int
var cost: int
var hovering:bool = false
var is_first_shake = true 
var shake_tween: Tween = null
var container_original_pos: Vector2
var insufficient_ram_container: ColorRect

var card_path: String


func _ready() -> void:
	if ram_stick_data:
		ram_stick_image.texture = ram_stick_data.ram_stick_image
		gb_size = ram_stick_data.gb_size
	button.hide()

	await get_tree().process_frame
	await  get_tree().process_frame
	insufficient_ram_container = get_tree().get_first_node_in_group("insufficient_ram")
	container_original_pos = insufficient_ram_container.position
	insufficient_ram_container.position = Vector2(757.0, 413.0)


func remove_from_setup():
	# Only allow unequip if sufficient RAM remains after
	if((GameData.current_ram_gb - gb_size) >= 0 ):
		GameData.remove_ram_from_setup(ram_stick_data)
		GameData.remove_current_ram(ram_stick_data)
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


func _on_equip_button_mouse_entered() -> void:
	button.show()


func _on_equip_button_mouse_exited() -> void:
	button.hide()


func _on_ram_stick_image_mouse_entered() -> void:
	button.show()


func _on_ram_stick_image_mouse_exited() -> void:
	if not button.is_hovered():
		button.hide()


func _on_remove_button_pressed() -> void:
	remove_from_setup()
