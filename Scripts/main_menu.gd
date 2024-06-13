extends Control

signal start_game(newgame)
signal end_game


@onready var Button_v_box = %ButtonVBox
@onready var worker_stats_button = get_node("/root/Game/UI/Control/worker_stats_view/worker_stats_button")

func _ready():
	focus_button()


func _on_start_game_button_pressed():
	print("_on_start_game_button_pressed")
	Global.new_game = true
	print("1emit_signal: ", emit_signal("start_game", true))
	worker_stats_button.show()
	hide()


func _on_setting_game_button_pressed():
	pass # Replace with function body.


func _on_quit_game_button_pressed():
	SaveSystem.save()
	get_tree().quit()


func _on_visibility_changed():
	if visible:
		focus_button()


func focus_button() -> void:
	if Button_v_box:
		var button: Button = Button_v_box.get_child(0)
		if button is Button:
			button.grab_focus()


func _on_control_startgame():
	print("asd")


func _on_continue_game_button_pressed():
	Global.new_game = false
	print("emit_signal: ", emit_signal("start_game", false))
	worker_stats_button.show()
	hide()
