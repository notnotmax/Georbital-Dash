extends Control
signal return_to_main_menu

@onready var main_menu_buttons = $MainMenuButtons
@onready var level_select = $LevelSelect

func _ready():
	level_select.hide()


func _on_play_button_pressed():
	main_menu_buttons.hide()
	level_select.show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_level_select_back():
	level_select.hide()
	main_menu_buttons.show()
