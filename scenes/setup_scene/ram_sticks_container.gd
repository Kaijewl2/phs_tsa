extends Control

const SETUP_RAM_SCENE = preload("res://scenes/setup_ram_scene/setup_ram.tscn")

@onready var ram_slots = [
	$ram_sticks_container/ram_slot_1_image,
	$ram_sticks_container/ram_slot_2_image,
	$ram_sticks_container/ram_slot_3_image,
	$ram_sticks_container/ram_slot_4_image,
]

func _ready() -> void:
	GameData.setup_changed.connect(refresh_ram_slots)
	refresh_ram_slots()

func refresh_ram_slots():
	for slot in ram_slots:
		for child in slot.get_children():
			child.queue_free()
	for i in range(GameData.setup_ram_types.size()):
		if i >= ram_slots.size():
			break
		var setup_ram = SETUP_RAM_SCENE.instantiate()
		setup_ram.ram_stick_data = GameData.setup_ram_types[i]
		ram_slots[i].add_child(setup_ram)
