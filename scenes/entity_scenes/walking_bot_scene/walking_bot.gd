extends CharacterBody2D

@export var unit_data: UnitData
var unit_name: String

# Base stats; never modified after _ready
var base_health: float
var base_damage: int
var base_speed: int
var attack_cooldown: float

# Current stats; what actually gets used in combat
var current_health: float
var current_damage: float
var current_speed: float

@onready var stats_ui: Control = $stats_UI
@onready var health_text: Label = $stats_UI/ColorRect/stats_container/health_text
@onready var damage_text: Label = $stats_UI/ColorRect/stats_container/damage_text
@onready var speed_text: Label = $stats_UI/ColorRect/stats_container/speed_text
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var name_text: Label = $stats_UI/ColorRect/stats_container/name_text
@onready var health_bar: CustomHealthBar = $health_bar

enum Context { IDLE, BATTLE, DEATH }
var current_context = Context.IDLE
var target = null
var attack_timer:float = 0.0
var ram_cost:int


func _ready() -> void:
	if unit_data:
		unit_name = unit_data.unit_name
		base_health = unit_data.health
		base_damage = unit_data.damage
		base_speed = unit_data.speed
		attack_cooldown = unit_data.attack_cooldown
		ram_cost = unit_data.ram_cost
		animated_sprite_2d.sprite_frames = unit_data.sprite_animations

	# Apply RAM buffs first, which sets current_health/damage/speed
	GameData.setup_changed.connect(apply_hardware_buffs)
	apply_hardware_buffs()

	# UI reflects buffed stats
	health_text.text += str(current_health)
	damage_text.text += str(current_damage)
	speed_text.text += str(current_speed)
	name_text.text += str(unit_name)

	health_bar._setup_health_bar(current_health)

	await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
	current_context = Context.BATTLE


func apply_ram_buffs() -> void:
	var bonuses = GameData.get_ram_stat_bonuses()
	current_damage = base_damage + (base_damage * bonuses["damage"])
	current_speed = base_speed + (base_speed * bonuses["speed"])

	# Recalculate max health but keep current damage taken
	var damage_taken = (base_health - current_health) if current_health > 0 else 0.0
	print("curr health: ", current_health)
	var new_max_health = base_health + (base_health * bonuses["health"])
	current_health = new_max_health - damage_taken

	# Update UI to reflect new stats
	health_bar._setup_health_bar(current_health)


func apply_hardware_buffs() -> void:
	var ram_bonuses = GameData.get_ram_stat_bonuses()
	var gpu_bonuses = GameData.get_gpu_stat_bonuses()
	var cpu_bonuses = GameData.get_cpu_stat_bonuses()

	current_damage = base_damage + (base_damage * (ram_bonuses["damage"] + gpu_bonuses["damage"] + cpu_bonuses["damage"]))
	current_speed = base_speed + (base_speed * (ram_bonuses["speed"] + gpu_bonuses["speed"]) + cpu_bonuses["speed"])

	var damage_taken = (base_health - current_health) if current_health > 0 else 0.0
	var new_max_health = base_health + (base_health * (ram_bonuses["health"] + gpu_bonuses["health"] + cpu_bonuses["health"]))
	current_health = new_max_health - damage_taken

	health_bar._setup_health_bar(current_health)


func take_damage(damage) -> void:
	current_health -= damage  # use current_health, not base

	if current_context != Context.DEATH:
		health_bar.change_value(current_health)

	if current_health <= 0 and current_context != Context.DEATH:
		death_logic()


func _process(delta) -> void:
	if current_context == Context.BATTLE:
		if not is_instance_valid(target) or not target.is_in_group("enemies"):
			find_target()
		else:
			battle_logic(delta)


func battle_logic(delta) -> void:
	attack_timer -= delta
	if attack_timer <= 0:
		attack(target)
		attack_timer = attack_cooldown


func attack(enemy) -> void:
	if not is_instance_valid(enemy):
		return
	animated_sprite_2d.play("attack")
	enemy.take_damage(current_damage)


func find_target() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if not enemies.is_empty():
		target = enemies[0]


func death_logic() -> void:
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
