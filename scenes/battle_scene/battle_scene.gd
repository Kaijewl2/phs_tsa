extends Node2D


@onready var enter_shop_button: Control = $enter_shop_button
@onready var balance_label: Control = $VBoxContainer/coin_counter
@onready var label: Label = $system_breach_container/system_breach_label
@onready var final_boss_win_label: Label = $final_boss_win_container/final_boss_win_label
@onready var enter_win_scene_button: TextureRect = $enter_win_scene_button
@onready var loss_restart_button: TextureRect = $loss_restart_button
@onready var level_image: TextureRect = $level_image


const ENENEMY_SCENE = preload("uid://dd11l81fddnsb")
const COMMRADE_SCENE = preload("uid://bdpc8podu70pj")
const CITY_MAP = preload("uid://b5nixpcmsqwfr")
const NEIGHBORHOOD_MAP = preload("uid://cii80imitrjdf")
const SPACE_ORBITAL_MAP = preload("uid://dnw66q782x4ar")

var maps = {"first_map" : NEIGHBORHOOD_MAP,
			"second_map" : CITY_MAP,
			"third_map" : SPACE_ORBITAL_MAP}
var active_units
var active_commrades
var active_enemies
var battle_over: bool = false
var enemy_type: String

func _ready() -> void:
	if GameData.battle_number <= 3:
		level_image.texture = NEIGHBORHOOD_MAP
	elif GameData.battle_number <= 6:
		level_image.texture = CITY_MAP
	else:
		level_image.texture = SPACE_ORBITAL_MAP
		
	
	GameData.balance_changed.connect(update_balance_display)
	balance_label.get_node("Label").text = str(GameData.get_balance())
	spawn_commrades()
	spawn_enemy()


func _process(_delta: float) -> void:
	if battle_over:
		return
	
	# Commrades lose
	if(GameData.active_commrades.is_empty()):
		loss_restart_button.show()
		battle_over = true
	
	# Commrades win
	elif(GameData.active_enemies.is_empty()):
		label.show()
		enter_shop_button.show()
		battle_over = true
		GameData.battle_number += 1
		
		if(enemy_type == "boss" and GameData.current_security_sweep > 3):
			GameData.increment_security_sweep()
		elif(enemy_type == "final_boss"):
			label.hide()
			enter_shop_button.show()
			
			final_boss_win_label.show()
			enter_win_scene_button.hide()
			
 

func spawn_commrades():
	clear_commrades()
	
	for card_data in GameData.setup_card_types:
		var commrade = COMMRADE_SCENE.instantiate()

		var commrade_type = GameData.unit_types.get(card_data.sell_card_name)
	
		commrade.unit_data = commrade_type
		
		commrade.position = Vector2(randi_range(300, 700), randi_range(470, 900))
		commrade.scale = Vector2(6.75,6.75)
	
		add_child(commrade)
	
		commrade.add_to_group("commrades")
		GameData.active_commrades.push_back(commrade)


func spawn_enemy():
	if GameData.is_boss_encounter():
		spawn_boss_virus()
	elif GameData.is_final_boss_encounter():
		spawn_final_boss_virus()
	else:
		spawn_minor_virus()


func spawn_minor_virus():
	var enemy_count = 1 + GameData.battle_number / 3
	
	for i in enemy_count:
		var enemy = ENENEMY_SCENE.instantiate()
		enemy.unit_data = GameData.get_random_normal_enemy_data()
		enemy.position = Vector2(randi_range(1200, 1350), randi_range(450, 900))
		enemy.scale = Vector2(10.0, 10.0)
		if GameData.battle_number > 6:
			enemy.DAMAGE *= 4
			enemy.HEALTH *= 4
		elif GameData.battle_number > 3:
			enemy.DAMAGE *= 3
			enemy.HEALTH *= 3
		
		
		enemy.add_to_group("enemies")
		GameData.active_enemies.push_back(enemy)
		add_child(enemy)
		
		enemy.health_bar._setup_health_bar(enemy.HEALTH)
		enemy_type = "minor"


func spawn_boss_virus():
	var boss = ENENEMY_SCENE.instantiate()

	boss.unit_data = GameData.get_random_boss_enemy_data()
	boss.position = Vector2(randi_range(1200, 1350), randi_range(530, 870))
	boss.scale = Vector2(20,20)
	boss.DEATH_VALUE = 15

	boss.add_to_group("enemies")
	GameData.active_enemies.push_back(boss)
	add_child(boss)
	

	boss.health_bar._setup_health_bar(boss.HEALTH)
	
	enemy_type = "boss"
	
	if GameData.battle_number > 5:
		var enemy = ENENEMY_SCENE.instantiate()
		enemy.unit_data = GameData.get_random_normal_enemy_data()
		enemy.position = Vector2(randi_range(1200, 1350), randi_range(450, 900))
		enemy.scale = Vector2(10.0, 10.0)
		enemy.DEATH_VALUE = 5
		enemy.DAMAGE *= 4
		enemy.HEALTH *= 4
		
		enemy.add_to_group("enemies")
		GameData.active_enemies.push_back(enemy)
		add_child(enemy)
		enemy.health_bar._setup_health_bar(enemy.HEALTH)
		enemy_type = "minor"


func spawn_final_boss_virus():
	var final_boss = ENENEMY_SCENE.instantiate()

	final_boss.unit_data = GameData.get_final_boss_enemy_data()
	final_boss.position = Vector2(1350,660)
	final_boss.scale = Vector2(25,25)


	final_boss.add_to_group("enemies")
	GameData.active_enemies.push_back(final_boss)
	add_child(final_boss)
	
	final_boss.health_bar._setup_health_bar(final_boss.HEALTH)
	
	enemy_type = "final_boss"
	
	var enemy_count = 2

	for i in enemy_count:
		var enemy = ENENEMY_SCENE.instantiate()
		enemy.unit_data = GameData.get_random_normal_enemy_data()
		enemy.position = Vector2(randi_range(1200, 1350), randi_range(450, 900))
		enemy.scale = Vector2(10.0, 10.0)
		enemy.DAMAGE *= 3
		enemy.HEALTH *= 3

		enemy.add_to_group("enemies")
		GameData.active_enemies.push_back(enemy)
		add_child(enemy)
		enemy.health_bar._setup_health_bar(enemy.HEALTH)
		enemy_type = "minor"


func clear_commrades():
	for commrade in GameData.active_commrades:
		if is_instance_valid(commrade):
			GameData.active_units.erase(commrade)
			commrade.queue_free()
			
	GameData.active_commrades.clear()


func update_balance_display(new_balance):
	balance_label.get_node("Label").text = str(new_balance)


func determine_next_scene():
	if GameData.battle_number == (GameData.BOSS_INTERVAL) + 1 or GameData.battle_number == (GameData.BOSS_INTERVAL) + 4 or GameData.battle_number == (GameData.BOSS_INTERVAL) + 7 or GameData.battle_number == (GameData.FINAL_BOSS_ROUND) + 1:
		get_tree().change_scene_to_file("res://scenes/cutscene_scene/cutscene_scene.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/shop/shop.tscn")


func _on_button_pressed() -> void:
	determine_next_scene()
