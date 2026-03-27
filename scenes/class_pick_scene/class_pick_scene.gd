extends Control


@export var node_class_type: String


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_img: TextureRect = $icon_img


var hovering:bool = false
var starting_scale:Vector2

func _ready() -> void:
	starting_scale = Vector2(1.57, 1.57)
	animation_player.play("rotate_star")


# Change scene to setup when class is chosen
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and hovering == true:
		if event.is_pressed():
			GameData.change_player_class(node_class_type)
			get_tree().change_scene_to_file("res://scenes/cutscene_scene/cutscene_scene.tscn")


func _on_mouse_entered() -> void:
	icon_img.scale = Vector2(starting_scale.x + 0.15, starting_scale.y + 0.15)
	hovering = true


func _on_mouse_exited() -> void:
	icon_img.scale = starting_scale
	hovering = false
