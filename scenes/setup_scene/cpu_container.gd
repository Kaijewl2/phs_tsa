extends Control


const SETUP_CPU_SCENE = preload("uid://brbsyxris1py7")


@onready var cpu_slot_image: TextureRect = $cpu_slot_image


func _ready() -> void:
	GameData.setup_changed.connect(refresh_cpu_slot)
	refresh_cpu_slot()

func refresh_cpu_slot():
	# Clear current gpu
	for child in cpu_slot_image.get_children():
		child.queue_free()

	# Populate if a CPU is equipped
	if GameData.setup_cpu_types.size() > 0:
		var setup_cpu = SETUP_CPU_SCENE.instantiate()
		setup_cpu.cpu_data = GameData.setup_cpu_types[0]
		setup_cpu.slot_index = 0
		cpu_slot_image.add_child(setup_cpu)
