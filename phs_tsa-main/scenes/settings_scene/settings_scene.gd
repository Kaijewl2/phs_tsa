extends Control


@onready var master_slider: HSlider = $settings_container/volume_label/volume_control_slider
@onready var music_slider: HSlider = $settings_container/music_label/music_slider
@onready var sfx_slider: HSlider = $settings_container/sfx_label/sfx_slider


func _ready() -> void:
	load_settings()
	master_slider.value_changed.connect(func(v): set_bus_volume("Master", v))
	music_slider.value_changed.connect(func(v): set_bus_volume("Music", v))
	sfx_slider.value_changed.connect(func(v): set_bus_volume("SFX", v))

func set_bus_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	save_settings()

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master", master_slider.value)
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		master_slider.value = config.get_value("audio", "master", 1.0)
		music_slider.value = config.get_value("audio", "music", 1.0)
		sfx_slider.value = config.get_value("audio", "sfx", 1.0)
	else:
		# No save file yet, set defaults
		master_slider.value = 1.0
		music_slider.value = 1.0
		sfx_slider.value = 1.0
	
	# Apply to buses regardless
	set_bus_volume("Master", master_slider.value)
	set_bus_volume("Music", music_slider.value)
	set_bus_volume("SFX", sfx_slider.value)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_scene/start_scene.tscn")
