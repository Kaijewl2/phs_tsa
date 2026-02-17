extends CharacterBody2D

@onready var stats_ui: Control = $stats_UI
@onready var health_text: Label = $stats_UI/ColorRect/stats_container/health_text
@onready var damage_text: Label = $stats_UI/ColorRect/stats_container/damage_text
@onready var speed_text: Label = $stats_UI/ColorRect/stats_container/speed_text
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: CustomHealthBar = $health_bar


@export var HEALTH = 50
@export var DAMAGE = 5
@export var SPEED = 5


enum Context {IDLE, BATTLE, DEATH}
var current_context = Context.IDLE
var target = null
var attack_cooldown:float = 3.0
var attack_timer:float = 0.0
var is_attacking: bool = false


func _ready() -> void:
	health_text.text += str(HEALTH)
	damage_text.text += str(DAMAGE)
	speed_text.text += str(SPEED)
	
	health_bar._setup_health_bar(HEALTH)


func _process(delta) -> void:
	if current_context == Context.BATTLE:
		# Enemy is eliminated
		if not is_instance_valid(target) or not target.is_in_group("enemies"):
			find_target()
		else:
			battle_logic(delta)
	elif current_context == Context.DEATH:
		pass
	


func battle_logic(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		attack(target)
		
		# Reset attack timer
		attack_timer = attack_cooldown


func attack(enemy):
	if not is_instance_valid(enemy):
		return
	
	animated_sprite_2d.play("attack")
	enemy.take_damage(DAMAGE)


func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if not enemies.is_empty():
		target = enemies[0]


func take_damage(damage):
	HEALTH -= damage
	health_bar.change_value(HEALTH)
	if HEALTH <= 0:
		GameData.active_commrades.erase(self)
		#queue_free()
		remove_from_group("commrades")


func death_logic():
	animated_sprite_2d.play("death")

func _on_area_2d_mouse_entered() -> void:
	stats_ui.show()
	current_context = Context.BATTLE


func _on_area_2d_mouse_exited() -> void:
	stats_ui.hide()
