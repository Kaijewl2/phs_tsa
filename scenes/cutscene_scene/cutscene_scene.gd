extends Control


@onready var current_cutscene_image: TextureRect = $current_cutscene_image

const SAS_MAP = preload("uid://28s3ifkaora")
const SPACE_ORBITAL_MAP = preload("uid://dnw66q782x4ar")
const NEIGHBORHOOD_MAP = preload("uid://cii80imitrjdf")
const CITY_MAP = preload("uid://b5nixpcmsqwfr")


var cutscene_images = [
	SAS_MAP, SPACE_ORBITAL_MAP, NEIGHBORHOOD_MAP, CITY_MAP
]


func _on_advance_cutscene_button_pressed() -> void:
	current_cutscene_image.texture = cutscene_images[GameData.current_cutscene]
	GameData.current_cutscene+=1
	
	if GameData.current_cutscene == 2:
		get_tree().change_scene_to_file("res://scenes/shop/shop.tscn")
