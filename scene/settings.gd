extends Control
@onready var bgm_bus_audio_id = AudioServer.get_bus_index("Music")
@onready var master_bus_audio_id = AudioServer.get_bus_index("Master")
@onready var music_player = AudioStreamPlayer.new()

func _ready():
	add_child(music_player)

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_audio_id, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus_audio_id, value < .05)


func _on_bgm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus_audio_id, linear_to_db(value))
	AudioServer.set_bus_mute(bgm_bus_audio_id, value < .05)


func _on_back_button_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()  # Putar musik
	
	var transition_timer_credit = Timer.new()
	add_child(transition_timer_credit)
	transition_timer_credit.wait_time = 1.0
	transition_timer_credit.one_shot = true
	transition_timer_credit.connect("timeout", Callable(self, "_change_scene_menu"))
	transition_timer_credit.start()

func _change_scene_menu() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")
