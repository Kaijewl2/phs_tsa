extends CharacterBody2D


@export var unit_data: UnitData


var unit_name:String
var HEALTH:float
var DAMAGE:int
var SPEED:int
var attack_cooldown:float
var sprite_animation: SpriteFrames


@onready var stats_ui: Control = $stats_UI
@onready var health_text: Label = $stats_UI/ColorRect/stats_container/health_text
@onready var damage_text: Label = $stats_UI/ColorRect/stats_container/damage_text
@onready var speed_text: Label = $stats_UI/ColorRect/stats_container/speed_text
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var name_text: Label = $stats_UI/ColorRect/stats_container/name_text
@onready var health_bar: CustomHealthBar = $health_bar

enum Context {IDLE, BATTLE, DEATH}
var current_context = Context.IDLE
var target = null
var attack_timer:float = 0.0


func _ready() -> void:
	
	if unit_data:
		unit_name = unit_data.unit_name
		HEALTH = unit_data.health
		DAMAGE = unit_data.damage
		SPEED = unit_data.speed
		attack_cooldown = unit_data.attack_cooldown
		animated_sprite_2d.sprite_frames = unit_data.sprite_animations
	
	health_text.text += str(HEALTH)
	damage_text.text += str(DAMAGE)
	speed_text.text += str(SPEED)
	name_text.text += str(unit_name)
	
	health_bar._setup_health_bar(HEALTH)
	
	# Random start attack time
	await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
	current_context = Context.BATTLE


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
	
	if current_context != Context.DEATH:
		health_bar.change_value(HEALTH)
		
	if HEALTH <= 0 and current_context != Context.DEATH:
		death_logic()


func death_logic():
	current_context = Context.DEATH
	
	animated_sprite_2d.rotation = -20
	animated_sprite_2d.play("death")
	GameData.active_commrades.erase(self)
	remove_from_group("commrades")
	
	await animated_sprite_2d.animation_finished
	queue_free()

 

func _on_area_2d_mouse_entered() -> void:
	stats_ui.show()


func _on_area_2d_mouse_exited() -> void:
	stats_ui.hide()
