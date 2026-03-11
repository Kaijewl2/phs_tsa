extends Node2D


@onready var label: Label = $Label
@onready var enter_shop_button: Control = $enter_shop_button
@onready var balance_label: Control = $VBoxContainer/coin_counter


const ENENEMY_SCENE = preload("uid://dd11l81fddnsb")
const COMMRADE_SCENE = preload("uid://bdpc8podu70pj")

var active_units
var active_commrades
var active_enemies


func _ready() -> void:
	GameData.balance_changed.connect(update_balance_display)
	balance_label.get_node("Label").text = str(GameData.get_balance())
	spawn_commrades()
	spawn_enemy()


func _process(_delta: float) -> void:
	# Commrades win
	if(GameData.active_commrades.is_empty()):
		print("Chuds have prevailed!")
	elif(GameData.active_enemies.is_empty()):
		label.show()
		enter_shop_button.show()
 

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
	var enemy = ENENEMY_SCENE.instantiate()
	
	enemy.unit_name = "Glaiel"
	enemy.HEALTH = 15.0
	enemy.DAMAGE = 10.0
	enemy.attack_cooldown = 8.0
	enemy.position = Vector2(randi_range(1200, 1550), randi_range(805, 850))
	enemy.scale = Vector2(6.325, 6.325)
	
	enemy.add_to_group("enemies")
	GameData.active_enemies.push_back(enemy)
	add_child(enemy)


func clear_commrades():
	for commrade in GameData.active_commrades:
		if is_instance_valid(commrade):
			GameData.active_units.erase(commrade)
			commrade.queue_free()
			
	GameData.active_commrades.clear()


func update_balance_display(new_balance):
	balance_label.get_node("Label").text = str(new_balance)
