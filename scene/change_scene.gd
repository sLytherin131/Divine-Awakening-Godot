extends Control


func _ready() -> void:
	Dialogic.signal_event.connect(_battle1_signal)
	Dialogic.signal_event.connect(_battle2_signal)
	Dialogic.signal_event.connect(_end_menu_signal)
	

func _battle1_signal(argument: String):
	if argument == "battle1":
		get_tree().change_scene_to_file("res://scene/BattleScene/firstbattle/battle1.tscn")
		

func _battle2_signal(argument: String):
	if argument == "battle2":
		get_tree().change_scene_to_file("res://scene/BattleScene2/Battle2.tscn")
	
func _end_menu_signal(argument: String):
	if argument == "menu":
		get_tree().change_scene_to_file("res://scene/menu.tscn")
