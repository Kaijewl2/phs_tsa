extends Control

const SETUP_GPU_SCENE = preload("res://scenes/setup_gpu_scene/setup_gpu.tscn")

@onready var gpu_slot: TextureRect = $gpu_slot_image

func _ready() -> void:
	GameData.setup_changed.connect(refresh_gpu_slot)
	refresh_gpu_slot()

func refresh_gpu_slot():
	# Clear current gpu
	for child in gpu_slot.get_children():
		child.queue_free()

	# Populate if a GPU is equipped
	if GameData.setup_gpu_types.size() > 0:
		var setup_gpu = SETUP_GPU_SCENE.instantiate()
		setup_gpu.gpu_data = GameData.setup_gpu_types[0]
		setup_gpu.slot_index = 0
		gpu_slot.add_child(setup_gpu)
