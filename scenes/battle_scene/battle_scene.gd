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
const CITY_MAP = preload("uid://con4qxwwnri1b")
const NEIGHBORHOOD_MAP = preload("uid://7jh1drblmlvj")
const SPACE_ORBITAL_MAP = preload("uid://gqn6f5ei3s7p")

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
		
		if(enemy_type == "boss"):
			GameData.increment_security_sweep()
		elif(enemy_type == "final_boss"):
			label.hide()
			enter_shop_button.hide()
			
			final_boss_win_label.show()
			enter_win_scene_button.show()
			
 

func spawn_commrades():
	clear_commrades()
	
	for card_data in GameData.setup_card_types:
		var commrade = COMMRADE_SCENE.instantiate()

		var commrade_type = GameData.unit_types.get(card_data.sell_card_name)
	
		commrade.unit_data = commrade_type
		
		commrade.position = Vector2(randi_range(500, 700), randi_range(530, 900))
		commrade.scale = Vector2(5.75,5.75)
	
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
		enemy.unit_data = GameData.get_random_entity_data()
		enemy.position = Vector2(randi_range(1200, 1350), randi_range(530, 900))
		enemy.scale = Vector2(6.325, 6.325)

		enemy.add_to_group("enemies")
		GameData.active_enemies.push_back(enemy)
		add_child(enemy)
		enemy_type = "minor"


func spawn_boss_virus():
	var boss = ENENEMY_SCENE.instantiate()

	boss.unit_data = GameData.get_random_entity_data()
	boss.position = Vector2(1350,830)
	boss.scale = Vector2(20,20)


	boss.add_to_group("enemies")
	GameData.active_enemies.push_back(boss)
	add_child(boss)
	
	boss.HEALTH *= 3
	boss.DAMAGE *= 2
	
	enemy_type = "boss"


func spawn_final_boss_virus():
	var final_boss = ENENEMY_SCENE.instantiate()

	final_boss.unit_data = GameData.get_random_entity_data()
	final_boss.position = Vector2(1350,660)
	final_boss.scale = Vector2(25,25)


	final_boss.add_to_group("enemies")
	GameData.active_enemies.push_back(final_boss)
	add_child(final_boss)
	
	final_boss.HEALTH *= 5
	final_boss.DAMAGE *= 3
	final_boss.modulate = Color(1.0, 0.118, 0.078, 1.0)
	
	enemy_type = "final_boss"


func clear_commrades():
	for commrade in GameData.active_commrades:
		if is_instance_valid(commrade):
			GameData.active_units.erase(commrade)
			commrade.queue_free()
			
	GameData.active_commrades.clear()


func update_balance_display(new_balance):
	balance_label.get_node("Label").text = str(new_balance)
