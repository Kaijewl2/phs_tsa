extends Node2D

signal hovered
signal hovered_off

@export var unit_scene_path:String = "res://scenes/test/walking_bot.tscn"

var unit_scene
var hand_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_scene = load(unit_scene_path)
	
	# All cards must be children of CardManager or err
	get_parent().connect_card_signals(self)


func create_unit():
	return unit_scene.instantiate()


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
