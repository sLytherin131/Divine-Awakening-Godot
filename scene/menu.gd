extends Control

@onready var startbutton = $VBoxContainer/StartButton
@onready var creditsbutton = $VBoxContainer/CreditsButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var music_player = AudioStreamPlayer.new()
@export var music_path: String

# AudioStreamPlayer node
var audio_player: AudioStreamPlayer

func _ready():
	add_child(music_player)

func _play_audio() -> void:
	# Create an AudioStreamPlayer node
	audio_player = AudioStreamPlayer.new()
	# Add the AudioStreamPlayer to the current scene
	add_child(audio_player)
	# Load the music file
	var music = load(music_path)
	if music:
		# Assign the music to the AudioStreamPlayer
		audio_player.stream = music
		# Play the music automatically
		audio_player.play()
	else:
		print("Failed to load music: " + music_path)


# Fungsi untuk menjalankan dialogic timeline
func _on_start_pressed() -> void:
	# Muat musik berformat .wav
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()  # Putar musik
	
	# Transisi ke scene lain setelah jeda tertentu (misalnya 2 detik)
	var transition_timer = Timer.new()
	add_child(transition_timer)
	transition_timer.wait_time = 0.5
	transition_timer.one_shot = true
	transition_timer.connect("timeout", Callable(self, "_change_scene_start"))
	transition_timer.start()

func _change_scene_start():
	var dialogic = Dialogic.start("res://timeline/timeline1.dtl")  # Load and start the dialogic timeline
	add_child(dialogic)  # Tambahkan dialog ke scene

# Fungsi untuk menampilkan scene credits
func _on_credits_button_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()  # Putar musik
	
	var transition_timer_credit = Timer.new()
	add_child(transition_timer_credit)
	transition_timer_credit.wait_time = 1.0
	transition_timer_credit.one_shot = true
	transition_timer_credit.connect("timeout", Callable(self, "_change_scene_credits"))
	transition_timer_credit.start()

func _change_scene_credits() -> void:
	get_tree().change_scene_to_file("res://scene/credits.tscn")


# Fungsi untuk keluar dari game
func _on_exit_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()# Putar musik
	
	var transition_timer_quit = Timer.new()
	add_child(transition_timer_quit)
	transition_timer_quit.wait_time = 1.0
	transition_timer_quit.one_shot = true
	transition_timer_quit.connect("timeout", Callable(self, "_quit"))
	transition_timer_quit.start()
	
func _quit() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()# Putar musik
	
	var transition_timer_quit = Timer.new()
	add_child(transition_timer_quit)
	transition_timer_quit.wait_time = 1.0
	transition_timer_quit.one_shot = true
	transition_timer_quit.connect("timeout", Callable(self, "_setting"))
	transition_timer_quit.start()

func _setting() -> void:
	get_tree().change_scene_to_file("res://scene/settings.tscn")
	
