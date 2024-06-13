extends CanvasLayer

signal start_game(newgame)
signal select_worker(worker_id)

signal change_worker()

@onready var worker_selector = %worker_selector
@onready var bulding_select_control = %bulding_select_control


func _ready():
	bulding_select_control.hide()


func _input(event):
	if event.is_action_pressed("preview_building"):
		Global.flip_preview_active()
		if Global.preview_active: 
			bulding_select_control.show()
		else:
			bulding_select_control.hide()
	elif event.is_action_pressed("place_building"):
		if Global.preview_active:
			pass



func _on_worker_1_button_pressed():
	print("_on_worker_1_button_pressed")
	Global.set_worker_name(1)
	# worker panel update
	print("emit_signal: ", emit_signal("change_worker"))


func _on_worker_2_button_pressed():
	print("_on_worker_2_button_pressed")
	Global.set_worker_name(2)
	print("emit_signal: ", emit_signal("change_worker"))

func _on_main_menu_start_game(newgame):
	worker_selector.show()
	print("2emit_signal: ", emit_signal("start_game", newgame))


