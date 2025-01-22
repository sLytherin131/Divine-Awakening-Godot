extends Node2D

@onready var music_player = AudioStreamPlayer.new()

func _ready():
	add_child(music_player)

func _on_back_button_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()  # Putar musik
	
	# Transisi ke scene lain setelah jeda tertentu (misalnya 2 detik)
	var transition_timer = Timer.new()
	add_child(transition_timer)
	transition_timer.wait_time = 1.0
	transition_timer.one_shot = true
	transition_timer.connect("timeout", Callable(self, "_change_scene_menu"))
	transition_timer.start()

func _change_scene_menu() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn") # Replace with function body.
