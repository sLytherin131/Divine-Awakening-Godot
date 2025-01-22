extends Control

@export var enemy_wolf: Resource = null

@export var music_path: String = "res://music/bgm/battlemusic.mp3"  # Tambahkan path musik
@onready var music_player_button = AudioStreamPlayer.new()
@export var audio_bus: String = "Music"  # Nama bus audio yang digunakan
@onready var bgm_bus_audio_id = AudioServer.get_bus_index("Music")
@onready var master_bus_audio_id = AudioServer.get_bus_index("Master")
@onready var music_player = AudioStreamPlayer.new()

var current_player_health = 0
var current_wolf_health = 0

func _ready():
	play_music(music_path, audio_bus, -10)
	set_health($PlayerPanel/PlayerData/Player/ProgressBar, State.current_health, State.max_health)
	set_health($EnemyBox/ProgressBar, enemy_wolf.health, enemy_wolf.health)
	$BlankPanel.hide()
	$SettingPanel.hide()
	$RetryPanel.hide()
	$EnemyBox/TextureRect/Wolf.texture = enemy_wolf.texture
	current_player_health = State.current_health
	current_wolf_health = enemy_wolf.health

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("label").text = "HP: %d/%d" % [health, max_health]

func _on_serang_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player_button.stream = music  # Setel musik ke AudioStreamPlayer
		music_player_button.play()
	$ActionPanel.visible = false
	$BlankPanel.visible = true
	# Tentukan damage secara acak
	var attack_damage = randf_range(10, 41)  # Rentang damage antara 500 hingga 1500
	# Tentukan pesan berdasarkan damage
	if attack_damage < 15:
		display_text("Sialan, hanya goresan saja!")
	elif attack_damage <= 35:
		display_text("Ini baru yang saya inginkan!")
	else:
		display_text("Serangan Mutahir!")
	await get_tree().create_timer(1).timeout
	play_effect_sound("res://music/bgm/punchsfx.mp3")
	await get_tree().create_timer(0.3).timeout
	# Kurangi health musuh
	current_wolf_health = max(0, current_wolf_health - attack_damage)
	set_health($EnemyBox/ProgressBar, current_wolf_health, enemy_wolf.health)
	$AnimationPlayer.play("wolf")
	
	await $AnimationPlayer.animation_finished
	if current_wolf_health <= 0:
		display_text("Canis Orpus sudah di kalahkan!")
		stop_music()  # Hentikan musik setelah display_text ditampilkan
		await get_tree().create_timer(1).timeout
		var _dialogic = Dialogic.start("res://timeline/timeline1_after_battle_2.dtl")
	else:
	# Musuh menyerang balik jika masih hidup
		enemy_attack()
		await get_tree().create_timer(2).timeout
	$ActionPanel.visible = true

func stop_music():
	if music_player and music_player.is_playing():
		music_player.stop()

func play_effect_sound(path: String) -> void:
	var effect_sound = load(path)
	if effect_sound:
		var effect_player = AudioStreamPlayer.new()
		effect_player.stream = effect_sound  # Setel efek suara ke AudioStreamPlayer
		add_child(effect_player)  # Tambahkan AudioStreamPlayer ke scene
		effect_player.play()  # Putar efek suara

func enemy_attack() -> void:
	# Tentukan damage serangan musuh secara acak (maksimal 25)
	var enemy_damage = randf_range(5, 30)
	# Kurangi health pemain
	current_player_health = max(0, current_player_health - enemy_damage)
	set_health($PlayerPanel/PlayerData/Player/ProgressBar, current_player_health, State.max_health)
	if enemy_damage < 10:
		display_text("Serangan Canis Orpus itu lemah!")
	elif enemy_damage <= 25:
		display_text("Serangan Canis Orpus cukup menyakitkan!")
	else:
		display_text("Serangan Canis Orpus sangat mematikan!")
	await get_tree().create_timer(2).timeout
	if current_player_health <= 0:
		display_text("Kamu telah dikalahkan oleh Canis Orpus!")
		await get_tree().create_timer(3).timeout
		$SettingPanel.visible = false
		$PlayerPanel.visible = false
		$ActionPanel.visible = false
		$BlankPanel.visible = false
		$RetryPanel.visible = true
	$BlankPanel.visible = false

func display_text(text):
	$BlankPanel.show()
	$BlankPanel/Label.text = text

# Fungsi untuk memainkan musik
func play_music(path, bus_name, volume: float = 0):
	if path != "":
		music_player.stream = load(path)  # Muat file musik
		music_player.bus = bus_name  # Atur bus audio
		music_player.volume_db = volume  # Atur volume dalam dB
		add_child(music_player)  # Tambahkan AudioStreamPlayer ke scene
		music_player.play()  # Putar musik


func _on_back_button_pressed() -> void:
	$SettingPanel.visible = false
	$PlayerPanel.visible = true
	$ActionPanel.visible = true


func _on_bgm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus_audio_id, linear_to_db(value))
	AudioServer.set_bus_mute(bgm_bus_audio_id, value < .05)


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_audio_id, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus_audio_id, value < .05)


func _on_setting_button_pressed() -> void:
	$ActionPanel.visible = false
	$PlayerPanel.visible = false
	$SettingPanel.visible = true


func _on_yes_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()  # Putar musik
	
	# Transisi ke scene lain setelah jeda tertentu (misalnya 2 detik)
	var transition_timer = Timer.new()
	add_child(transition_timer)
	transition_timer.wait_time = 0.5
	transition_timer.one_shot = true
	transition_timer.connect("timeout", Callable(self, "_restart"))
	transition_timer.start()

func _restart() -> void:
	get_tree().change_scene_to_file("res://scene/BattleScene2/Battle2.tscn")

func _on_no_pressed() -> void:
	var music = load("res://music/bgm/button_pressed.wav")  # Ganti dengan path file musik Anda
	if music:
		music_player.stream = music  # Setel musik ke AudioStreamPlayer
		music_player.play()  # Putar musik
	
	# Transisi ke scene lain setelah jeda tertentu (misalnya 2 detik)
	var transition_timer = Timer.new()
	add_child(transition_timer)
	transition_timer.wait_time = 0.5
	transition_timer.one_shot = true
	transition_timer.connect("timeout", Callable(self, "_game_menu"))
	transition_timer.start()

func _game_menu() -> void:
	get_tree().quit()
