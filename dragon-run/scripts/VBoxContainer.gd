extends VBoxContainer

@onready var start_button = $StartButton
@onready var exit_game = $"ExitGame"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	exit_game.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
