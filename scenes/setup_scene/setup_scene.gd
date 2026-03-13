extends Node2D


@onready var next_virus_label: Label = $motherboard_layout/stats_container/next_virus_container/next_virus_label
@onready var encounter_label: Label = $motherboard_layout/stats_container/encounter_bar/encounter_label
@onready var next_virus_icon: TextureRect = $motherboard_layout/stats_container/next_virus_container/next_virus_frame/next_virus_icon


const VIRUS_ICON = preload("uid://ctgxc6bxk1yv5")
const BOSS_VIRUS_ICON = preload("uid://brg8owixn5eja")


func _ready() -> void:
	if GameData.is_boss_encounter():
		choose_boss_virus_name()
	else:
		choose_minor_virus_name()
	
	if rounds_until_next_boss() == 0:
		encounter_label.label_settings.font_color = Color(0.27, 0.002, 0.002, 1.0)
		next_virus_label.label_settings.font_color = Color(0.27, 0.002, 0.002, 1.0)
		encounter_label.text = "CRITICAL VIRUS DETECTED"
		next_virus_icon.texture = BOSS_VIRUS_ICON
	else:
		encounter_label.text += str(rounds_until_next_boss())
		next_virus_label.label_settings.font_color = Color(0.738, 0.644, 0.013, 1.0)
		encounter_label.label_settings.font_color = Color(0.738, 0.644, 0.013, 1.0)
		next_virus_icon.texture = VIRUS_ICON
		

func choose_minor_virus_name():
	next_virus_label.text += GameData.get_random_minor_virus_name()


func choose_boss_virus_name():
	next_virus_label.text += GameData.get_random_boss_virus_name()


func rounds_until_next_boss():
	var remainder = GameData.battle_number % GameData.BOSS_INTERVAL
	if remainder == 0:
		return 0
	return GameData.BOSS_INTERVAL - remainder
