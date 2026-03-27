extends Node2D


@onready var next_virus_label: Label = $motherboard_layout/stats_container/next_virus_container/next_virus_label
@onready var encounter_label: Label = $motherboard_layout/stats_container/encounter_bar/encounter_label
@onready var next_virus_icon: TextureRect = $motherboard_layout/stats_container/next_virus_container/next_virus_frame/next_virus_icon
@onready var security_sweep_label: Label = $motherboard_layout/security_sweep_rect/security_sweep_label
@onready var ram_bar: ProgressBar = $motherboard_layout/stats_container/ram_bar_container/ram_bar
@onready var change_scene_button: Control = $change_scene_button
@onready var to_encounter_button: Button = $to_encounter_button
@onready var tutorial_container: Control = $tutorial_container


var is_first_shake = true 
var shake_tween: Tween = null
var container_original_pos: Vector2
var add_card_message_container: ColorRect


const BATTLE_SCENE_PATH = "res://scenes/battle_scene/battle_scene.tscn"
const VIRUS_ICON = preload("uid://ctgxc6bxk1yv5")
const FINAL_VIRUS_ICON = preload("uid://brg8owixn5eja")
const BOSS_VIRUS_ICON = preload("uid://2eg5npvd305u")


func _ready() -> void:
	GameData.ram_changed.connect(update_ram_bar)
	ram_bar.value = GameData.current_ram_gb
	
	await get_tree().process_frame
	await  get_tree().process_frame
	add_card_message_container = get_tree().get_first_node_in_group("add_card_message")
	container_original_pos = add_card_message_container.position
	add_card_message_container.position = Vector2(349.0, 413.0)
	
	if !GameData.added_starting_card:
		GameData.add_starting_gear()
	
	if !GameData.tutorial_played:
		tutorial_container.show()
		GameData.tutorial_played = true
	else:
		tutorial_container.hide()
		tutorial_container.queue_free()
	
	security_sweep_label.text += str(GameData.current_security_sweep)
	
	if GameData.is_boss_encounter():
		choose_boss_virus_name()
	elif GameData.is_final_boss_encounter():
		choose_final_boss_virus_name()
	else:
		choose_minor_virus_name()
	
	if rounds_until_next_boss() == 0:
		encounter_label.label_settings.font_color = Color(0.725, 0.384, 0.0)
		next_virus_label.label_settings.font_color = Color(0.725, 0.384, 0.0)
		encounter_label.text = "MAJOR VIRUS DETECTED"
		next_virus_icon.texture = BOSS_VIRUS_ICON
	elif rounds_until_final_boss() == 0:
		encounter_label.label_settings.font_color = Color(0.27, 0.002, 0.002, 1.0)
		next_virus_label.label_settings.font_color = Color(0.27, 0.002, 0.002, 1.0)
		encounter_label.text = "SYSTEM VIRUS DETECTED"
		next_virus_icon.texture = FINAL_VIRUS_ICON
	else:
		encounter_label.text += str(rounds_until_next_boss())
		next_virus_label.label_settings.font_color = Color(0.738, 0.644, 0.013, 1.0)
		encounter_label.label_settings.font_color = Color(0.738, 0.644, 0.013, 1.0)
		next_virus_icon.texture = VIRUS_ICON


func update_ram_bar():
	ram_bar.max_value = GameData.MAX_RAM_GB
	ram_bar.value = GameData.current_ram_gb


func choose_minor_virus_name():
	next_virus_label.text += GameData.get_random_minor_virus_name()


func choose_boss_virus_name():
	next_virus_label.text += GameData.get_random_boss_virus_name()


func choose_final_boss_virus_name():
	next_virus_label.text += GameData.get_random_final_boss_virus_name()


func rounds_until_next_boss():
	var remainder = GameData.battle_number % GameData.BOSS_INTERVAL
	if remainder == 0:
		return 0
	return GameData.BOSS_INTERVAL - remainder
	
func rounds_until_final_boss():
	var remainder = GameData.battle_number % GameData.FINAL_BOSS_ROUND
	if remainder == 0:
		return 0
	return GameData.FINAL_BOSS_ROUND - remainder


func anim_shake(node):
	add_card_message_container.position = Vector2(349.0, 413.0)
	container_original_pos = add_card_message_container.position
	
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
		node.position = container_original_pos 
	
	shake_tween = create_tween()
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(-10, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(10, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(-5, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos + Vector2(5, 0), 0.05)
	shake_tween.tween_property(node, "position", container_original_pos, 0.05)
	shake_tween.tween_interval(1.3)
	shake_tween.tween_callback(node.hide)


func _on_to_encounter_button_pressed() -> void:
	if GameData.active_units.size() > 0:
		get_tree().change_scene_to_file(BATTLE_SCENE_PATH)
	else:
		add_card_message_container.show()
		
		anim_shake(add_card_message_container)
