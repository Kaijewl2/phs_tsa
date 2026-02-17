extends CharacterBody2D

@export var HEALTH: float = 50.0
@export var DAMAGE = 3
@export var SPEED = 5
@export var DEATH_VALUE = 5

@onready var health_bar: CustomHealthBar = $health_bar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const COIN_SCENE = preload("uid://nnmw0hp41ppt")
const UI_ELEMENTS_SCENE = preload("uid://cifwypi1j3oks")


enum Context {IDLE, BATTLE, DEATH}
var target = null
var commrades = []
var current_context = Context.BATTLE
var attack_cooldown:float = 5.0
var attack_timer:float = 0.0
var is_attacking: bool = false
var ui_elements


func _ready() -> void:
	health_bar._setup_health_bar(HEALTH)


func _process(delta: float) -> void:
		if current_context == Context.BATTLE:
			# Enemy is eliminated
			if not is_instance_valid(target) or not target.is_in_group("commrades"):
				find_target()
			else:
				battle_logic(delta)
		elif current_context == Context.DEATH:
			death_logic()


func battle_logic(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		attack(target)
		
		# Reset attack timer
		attack_timer = attack_cooldown


func death_logic():
	if(animated_sprite_2d.animation != "death"):
		var coin = COIN_SCENE.instantiate()
		get_parent().add_child(coin)
		coin.global_position = Vector2(randf_range(self.global_position.x - 50, self.global_position.x + 50), randi_range(self.global_position.y - 50, self.global_position.y + 50))
		GameData.change_balance(DEATH_VALUE, "add")
		print(GameData.get_balance())
		
		animated_sprite_2d.play("death")
		GameData.active_enemies.erase(self)
		remove_from_group("enemies")


func attack(commrade):
	if not is_instance_valid(commrade):
		return
	
	animated_sprite_2d.play("attack")
	commrade.take_damage(DAMAGE)


func take_damage(damage):
	HEALTH -= damage
	health_bar.change_value(HEALTH)
	
	# Bot dies
	if HEALTH <= 0:
		current_context = Context.DEATH


func find_target():
	commrades = get_tree().get_nodes_in_group("commrades")
	if not commrades.is_empty():
		target = commrades[0]


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			take_damage(50)


func _on_area_2d_mouse_entered() -> void:
	pass
