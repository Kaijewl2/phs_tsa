extends Control

@onready var card_grid: GridContainer = $storage_img/GridContainer
const BACKPACK_CARD_SCENE = preload("res://scenes/backpack_card_scene/backpack_card.tscn")
const BACKPACK_RAM_SCENE = preload("res://scenes/backpack_ram_scene/backpack_ram.tscn")
const BACKPACK_GPU_SCENE = preload("res://scenes/backpack_gpu_scene/backpack_gpu.tscn")
const BACKPACK_CPU_SCENE = preload("res://scenes/backpack_cpu/backpack_cpu.tscn")


func _ready() -> void:
	GameData.backpack_changed.connect(refresh_backpack)
	refresh_backpack()


func refresh_backpack():
	for child in card_grid.get_children():
		child.queue_free()

	for item in GameData.backpack_items:
		if item["type"] == "card":
			var backpack_card = BACKPACK_CARD_SCENE.instantiate()
			backpack_card.backpack_card_data = item["data"]
			card_grid.add_child(backpack_card)
			backpack_card.setup(item["path"])
		elif item["type"] == "ram":
			var backpack_ram = BACKPACK_RAM_SCENE.instantiate()
			backpack_ram.ram_stick_data = item["data"]
			card_grid.add_child(backpack_ram)
			backpack_ram.setup(item["path"])
		elif item["type"] == "gpu":
			var backpack_gpu = BACKPACK_GPU_SCENE.instantiate()
			backpack_gpu.gpu_data = item["data"]
			card_grid.add_child(backpack_gpu)
			backpack_gpu.setup(item["path"])
		elif item["type"] == "cpu":
			var backpack_cpu = BACKPACK_CPU_SCENE.instantiate()
			backpack_cpu.cpu_data = item["data"]
			card_grid.add_child(backpack_cpu)
			backpack_cpu.setup(item["path"])
			
func toggle_visibility():
	visible = !visible
