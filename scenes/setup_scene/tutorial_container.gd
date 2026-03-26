extends Control


@onready var brick_dialog: RichTextLabel = $dialog_background/brick_dialog
@onready var brick_dialog_sfx: AudioStreamPlayer2D = $brick_dialog_sfx
@onready var brick_animation: AnimationPlayer = $brick_animation
@onready var tutorial_container: Control = $"."


var visible_characters: int = 0
var current_line: int = 0
var is_waiting: bool = false
var typing_speed: float = 0.4

var dialog_lines: Array = [
	"These viruses are running amock",
	"Bad for business the whole thing is",
	"Somebody's gonna have to do something about it",
	"You look like a brave and capable fella...",
	"if I squint my eyes hard enough",
	"It's decided then",
	"you'll clear these viruses and save the world!",
	"I'll lend you this card, RAM stick, and motherboard",
	"Cards like that one cost GB to use",
	"Equip the RAM stick to your motherboard",
	"It'll give your enough GB to equip that card",
	"Stop by my shop after clearing some viruses",
	"I'll sell you more RAM sticks and cards",
	"I also sell other items you'll find valuable",
	"Enough talk out of you",
	"go clear some viruses so my customers come back"
]


func _ready() -> void:
	show_line(0)


func show_line(index: int) -> void:
	# All lines shown
	if index >= dialog_lines.size():
		hide()
		return
	
	current_line = index
	brick_dialog.text = dialog_lines[index]
	brick_dialog.visible_ratio = 0
	is_waiting = false


func _process(delta: float) -> void:
	# Still typing
	if brick_dialog.visible_ratio < 1:
		brick_dialog.visible_ratio += typing_speed * delta

		if visible_characters != brick_dialog.visible_characters:
			visible_characters = brick_dialog.visible_characters
			brick_dialog_sfx.play()
			brick_animation.play("talk")
	else:
		brick_dialog_sfx.stop()
		brick_animation.stop()

		# Finished typing, wait then move to next line
		if not is_waiting:
			is_waiting = true
			await get_tree().create_timer(2.0).timeout
			show_line(current_line + 1)


func _on_skip_button_pressed() -> void:
	GameData.user_skipped_tutorial = true
	tutorial_container.queue_free()
