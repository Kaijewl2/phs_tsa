extends Control


@onready var card_grid: GridContainer = $storage_img/GridContainer
@onready var manage_button: Button = $"../motherboard_layout/manage_button_container/manage_button"
@onready var manage_button_container: TextureRect = $"../motherboard_layout/manage_button_container"
@onready var available_slots_label: Label = $available_slots_container/available_slots_label


const BACKPACK_CARD_SCENE = preload("res://scenes/backpack_card_scene/backpack_card.tscn")
const BACKPACK_RAM_SCENE = preload("res://scenes/backpack_ram_scene/backpack_ram.tscn")
const BACKPACK_GPU_SCENE = preload("res://scenes/backpack_gpu_scene/backpack_gpu.tscn")
const BACKPACK_CPU_SCENE = preload("res://scenes/backpack_cpu/backpack_cpu.tscn")


var is_remove_mode:bool = false


func _ready() -> void:
	available_slots_label.text = str(int(GameData.MAX_BACKPACK_SIZE - (GameData.backpack_items.size()))) + " / " + str(int(GameData.MAX_BACKPACK_SIZE))
	
	GameData.backpack_changed.connect(refresh_backpack)
	manage_button.pressed.connect(toggle_remove_mode)
	refresh_backpack()


func toggle_remove_mode():
	is_remove_mode = !is_remove_mode
	
	if is_remove_mode:
		available_slots_label.modulate = Color(1.0, 0.0, 0.0)
		manage_button.text = "Mode - 
		remove from backpack"
		manage_button_container.modulate = Color.DARK_RED
	else:
		available_slots_label.modulate = Color(1.0, 1.0, 1.0)
		manage_button.text = "Mode - 
		add to setup"
		manage_button_container.modulate = Color.WHITE
	
	refresh_backpack()


func refresh_backpack():
	
	available_slots_label.text = str(int(GameData.MAX_BACKPACK_SIZE - (GameData.backpack_items.size()))) + " / " + str(int(GameData.MAX_BACKPACK_SIZE))
	
	for child in card_grid.get_children():
		child.queue_free()

	for item in GameData.backpack_items:
		if item["type"] == "card":
			var backpack_card = BACKPACK_CARD_SCENE.instantiate()
			backpack_card.backpack_card_data = item["data"]
			card_grid.add_child(backpack_card)
			backpack_card.setup(item["path"], is_remove_mode)
		elif item["type"] == "ram":
			var backpack_ram = BACKPACK_RAM_SCENE.instantiate()
			backpack_ram.ram_stick_data = item["data"]
			card_grid.add_child(backpack_ram)
			backpack_ram.setup(item["path"], is_remove_mode)
		elif item["type"] == "gpu":
			var backpack_gpu = BACKPACK_GPU_SCENE.instantiate()
			backpack_gpu.gpu_data = item["data"]
			card_grid.add_child(backpack_gpu)
			backpack_gpu.setup(item["path"], is_remove_mode)
		elif item["type"] == "cpu":
			var backpack_cpu = BACKPACK_CPU_SCENE.instantiate()
			backpack_cpu.cpu_data = item["data"]
			card_grid.add_child(backpack_cpu)
			backpack_cpu.setup(item["path"], is_remove_mode)


func toggle_visibility():
	visible = !visible


func _on_manage_button_mouse_entered() -> void:
	manage_button_container.scale = Vector2(1.05, 1.05)

func _on_manage_button_mouse_exited() -> void:
	manage_button_container.scale = Vector2(1.0, 1.0)
