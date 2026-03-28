extends Control


@onready var brick_dialog: RichTextLabel = $dialog_background/brick_dialog
@onready var brick_dialog_sfx: AudioStreamPlayer2D = $brick_dialog_sfx
@onready var brick_animation: AnimationPlayer = $brick_animation
@onready var tutorial_container: Control = $"."
@onready var backpack_grid: GridContainer = $"../backpack_container/storage_img/GridContainer"
@onready var available_slots_label: Label = $"../backpack_container/available_slots_container/available_slots_label"
@onready var equip_instruction_container: Control = $"../equip_instruction_container"


var visible_characters: int = 0
var current_line: int = 0
var is_waiting: bool = false
var typing_speed: float = 0.45

var dialog_lines: Array = [
	"These viruses are running amock",
	"You can stop them and save the world right?",
	"I'll lend you this card and RAM stick",
	"Cards like that one cost GB to use",
	"Equip the RAM stick to your motherboard",
	"It'll give your enough GB to equip that card",
	"Stop by my shop after clearing some viruses",
	"I'll sell you more items there",
	"Now go clear those viruses!"
]


func _ready() -> void:
	backpack_grid.hide()
	available_slots_label.hide()
	equip_instruction_container.hide()
	show_line(0)


func show_line(index: int) -> void:
	# All lines shown
	if index >= dialog_lines.size():
		hide()
		backpack_grid.show()
		available_slots_label.show()
		if !GameData.ram_interacted:
			equip_instruction_container.show()
			
		return
	
	current_line = index
	brick_dialog.text = dialog_lines[index]
	brick_dialog.visible_ratio = 0
	is_waiting = false
	
	if dialog_lines[index] == "I'll lend you this card and RAM stick":
		backpack_grid.hide()
		available_slots_label.hide()
	if index > dialog_lines.find("I'll lend you this card and RAM stick"):
		backpack_grid.show()
		available_slots_label.show()

	if index > dialog_lines.find("Equip the RAM stick to your motherboard") and !GameData.ram_interacted:
		equip_instruction_container.show()

func _process(delta: float) -> void:
	if brick_dialog.visible_ratio < 1:
		brick_dialog.visible_ratio += typing_speed * delta
		if visible_characters != brick_dialog.visible_characters:
			visible_characters = brick_dialog.visible_characters
			brick_dialog_sfx.play()
			brick_animation.play("talk")
	else:
		brick_dialog_sfx.stop()
		brick_animation.stop()


func _on_skip_button_pressed() -> void:
	GameData.user_skipped_tutorial = true
	backpack_grid.show()
	available_slots_label.show()
	if !GameData.ram_interacted:
		equip_instruction_container.show()
		
	tutorial_container.queue_free()


func _on_next_button_pressed() -> void:
	if brick_dialog.visible_ratio < 1:
		# Skip typing, show full line immediately
		brick_dialog.visible_ratio = 1
	else:
		# Line fully shown, advance to next
		show_line(current_line + 1)
