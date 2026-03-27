extends Control


@onready var current_cutscene_image: TextureRect = $current_cutscene_image


const SCENE_1 = preload("uid://b00si68gdkbtl")
const SCENE_2 = preload("uid://c3b27xe5kpb7m")
const SCENE_3 = preload("uid://wo3v1swhgcso")
const SCENE_4 = preload("uid://cnvakkd1boys2")
const SCENE_5 = preload("uid://bhrd2msvqgr0d")
const SCENE_6 = preload("uid://d30pq6rkvg6lk")
const SCENE_7 = preload("uid://u0448trdkgsg")
const SCENE_8 = preload("uid://cx1hu22olfcyj")
const SCENE_9 = preload("uid://bj2t2mgcb6wbo")
const SCENE_10 = preload("uid://nx3tns01u5wn")
const SCENE_11 = preload("uid://qbx8bdr13g22")
const SCENE_12 = preload("uid://2vfb21d5ihyp")


var cutscene_images = [
	SCENE_2, SCENE_3, SCENE_4, 
	SCENE_5, SCENE_6, SCENE_7,
	SCENE_8, SCENE_9, SCENE_10,
	SCENE_11,SCENE_12
]


func _ready() -> void:
	if GameData.current_cutscene >= 1:
		current_cutscene_image.texture = cutscene_images[GameData.current_cutscene - 1]


func _on_advance_cutscene_button_pressed() -> void:
	print(GameData.current_cutscene)
	current_cutscene_image.texture = cutscene_images[GameData.current_cutscene]
	GameData.current_cutscene+=1
	
	if GameData.current_cutscene == 4:
		get_tree().change_scene_to_file("res://scenes/setup_scene/setup_scene.tscn")
	
	if GameData.current_cutscene == 6:
		get_tree().change_scene_to_file("res://scenes/shop/shop.tscn")
		
	if GameData.current_cutscene == 9:
		get_tree().change_scene_to_file("res://scenes/shop/shop.tscn")
	
	if GameData.current_cutscene == 10:
		get_tree().change_scene_to_file("res://scenes/shop/shop.tscn")
	
	if GameData.current_cutscene == 11:
		get_tree().change_scene_to_file("res://scenes/win_scene/win_scene.tscn")
