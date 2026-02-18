extends Node2D


@onready var label: Label = $Label
@onready var enter_shop_button: Control = $enter_shop_button
@onready var balance_label: Control = $VBoxContainer/coin_counter


const WALKING_BOT_ENEMY = preload("uid://dd11l81fddnsb")
const WALKING_BOT = preload("uid://bdpc8podu70pj")


var active_units
var active_commrades
var active_enemies


func _ready() -> void:
	GameData.balance_changed.connect(update_balance_display)
	balance_label.get_node("Label").text = str(GameData.get_balance())
	
	for data in GameData.active_units:
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
	var commrade = WALKING_BOT.instantiate()
	
	commrade.position = Vector2(randi_range(400, 700), randi_range(730, 870))
	commrade.get_node("AnimatedSprite2D").animation = "idle"
	commrade.get_node("AnimatedSprite2D").play()
	commrade.scale = Vector2(5.75,5.75)
	
	commrade.add_to_group("commrades")
	GameData.active_commrades.push_back(commrade)
	add_child(commrade)


func spawn_enemy():
	var enemy = WALKING_BOT_ENEMY.instantiate()
	
	enemy.position = Vector2(randi_range(1200, 1550), randi_range(805, 850))
	enemy.scale = Vector2(6.325, 6.325)
	
	enemy.add_to_group("enemies")
	GameData.active_enemies.push_back(enemy)
	add_child(enemy)


func update_balance_display(new_balance):
	balance_label.get_node("Label").text = str(new_balance)
