extends Node2D


@onready var label: Label = $Label
@onready var enter_shop_button: Control = $enter_shop_button
@onready var balance_label: Control = $VBoxContainer/coin_counter


const ENENEMY_SCENE = preload("uid://dd11l81fddnsb")
const COMMRADE_SCENE = preload("uid://bdpc8podu70pj")

var active_units
var active_commrades
var active_enemies
var battle_over: bool = false

func _ready() -> void:
	GameData.balance_changed.connect(update_balance_display)
	balance_label.get_node("Label").text = str(GameData.get_balance())
	spawn_commrades()
	spawn_enemy()
	print("current battle: ", GameData.battle_number)


func _process(_delta: float) -> void:
	if battle_over:
		return
	
	# Commrades lose
	if(GameData.active_commrades.is_empty()):
		print("Chuds have prevailed!")
		battle_over = true
	
	# Commrades win
	elif(GameData.active_enemies.is_empty()):
		label.show()
		enter_shop_button.show()
		GameData.battle_number += 1
		battle_over = true
 

func spawn_commrades():
	clear_commrades()
	
	for card_data in GameData.setup_card_types:
		var commrade = COMMRADE_SCENE.instantiate()

		var commrade_type = GameData.unit_types.get(card_data.sell_card_name)
	
		commrade.unit_data = commrade_type
		
		commrade.position = Vector2(randi_range(400, 700), randi_range(730, 870))
		commrade.scale = Vector2(5.75,5.75)
	
		add_child(commrade)
	
		commrade.add_to_group("commrades")
		GameData.active_commrades.push_back(commrade)


func spawn_enemy():
	if GameData.is_boss_encounter():
		spawn_boss_virus()
	else:
		spawn_minor_virus()


func spawn_minor_virus():
	var enemy_count = 1 + GameData.battle_number / 3
	
	for i in enemy_count:
		var enemy = ENENEMY_SCENE.instantiate()
		enemy.unit_data = GameData.get_random_entity_data()
		enemy.position = Vector2(randi_range(1200, 1550), randi_range(805, 850))
		enemy.scale = Vector2(6.325, 6.325)

		enemy.add_to_group("enemies")
		GameData.active_enemies.push_back(enemy)
		add_child(enemy)


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
	
	print("boss health: ", boss.HEALTH)
	print("boss dmg: ", boss.DAMAGE)


func clear_commrades():
	for commrade in GameData.active_commrades:
		if is_instance_valid(commrade):
			GameData.active_units.erase(commrade)
			commrade.queue_free()
			
	GameData.active_commrades.clear()


func update_balance_display(new_balance):
	balance_label.get_node("Label").text = str(new_balance)
