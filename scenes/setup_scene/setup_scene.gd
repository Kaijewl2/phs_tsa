extends Node2D


@onready var next_virus_label: Label = $motherboard_layout/stats_container/next_virus_container/next_virus_label
@onready var encounter_label: Label = $motherboard_layout/stats_container/encounter_bar/encounter_label
@onready var next_virus_icon: TextureRect = $motherboard_layout/stats_container/next_virus_container/next_virus_frame/next_virus_icon
@onready var security_sweep_label: Label = $motherboard_layout/security_sweep_rect/security_sweep_label
@onready var ram_bar: ProgressBar = $motherboard_layout/stats_container/ram_bar_container/ram_bar


const VIRUS_ICON = preload("uid://ctgxc6bxk1yv5")
const FINAL_VIRUS_ICON = preload("uid://brg8owixn5eja")
const BOSS_VIRUS_ICON = preload("uid://2eg5npvd305u")


func _ready() -> void:
	GameData.ram_changed.connect(update_ram_bar)
	ram_bar.value = GameData.current_ram_gb
	
	if !GameData.added_starting_card:
		GameData.add_starting_gear()
	
	
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
	print(ram_bar.value)


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
