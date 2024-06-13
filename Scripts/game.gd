extends Node2D

@export var WorldScene : PackedScene
@export var WorkerScene : PackedScene
@export var ui : CanvasLayer

@onready var camera : Camera2D = %Camera2D


var world
var worker1
var worker2
var worker3
var worker4


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start_game(newgame):
	print("Game is starting.")
	
	if (newgame):
		SaveSystem.clearfiles()
		SaveSystem.set_file_worker()
	else:
		SaveSystem.load()
	
	world = WorldScene.instantiate()
	add_child(world)
	move_child(world, 2)
	
	
	"""worker1 = WorkerScene.instantiate()
	worker1.name = "worker1"
	worker1.position = Vector2(0,0)
	add_child(worker1)
	move_child(worker1, 0)
	"""
	
	var worker = load("res://Assets/Scenes/worker.tscn").instantiate()
	worker.name = "worker1"
	worker.position = Vector2(0,0)
	move_child(worker, 0)
	add_child(worker)
	
	var worker2 = WorkerScene.instantiate()
	worker2.name = "worker2"
	worker2.position = Vector2(1000,1000)
	add_child(worker2)
	move_child(worker1, 0)
	
	var ui_pannel = get_node("/root/Game/UI/Control/worker_stats_view/worker_stats_button")
	# Überprüfen, ob das Signal existiert
	if not worker.has_signal("reload_worker_panel"):
		print("Worker hat kein Signal 'reload_worker_panel'")
		return

	# Überprüfen, ob die Methode im UI existiert
	if not ui_pannel.has_method("_on_reload_worker_panel"):
		print("UI-Panel hat keine Methode '_on_reload_worker_panel'")
		return

	# Verbindung herstellen
	var connect_result = worker.connect("reload_worker_panel", Callable(ui_pannel, "_on_reload_worker_panel"))
	print("connect2: ", worker2.connect("reload_worker_panel", Callable(ui_pannel, "_on_reload_worker_panel")))

	if connect_result != OK:
		print("Fehler beim Verbinden des Signals: ", connect_result)   

	
	var bulding_select_control = get_node("/root/Game/UI/Control/bulding_select_control")
	
	if worker.connect("pressed", Callable(bulding_select_control, "_on_ui_button_pressed")):
		print("pressed not working_on_ui_button_pressed")
		return
	
	# Überprüfen, ob das Signal existiert
	if not worker.has_signal("reload_worker_panel"):
		print("Worker hat kein Signal 'reload_worker_panel'")
		return
	
	

func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().quit()


func _on_button_pressed():
	print("_on_button_pressed")


func _on_ui_select_worker():
	print("UIMAIN_on_ui_select_worker")


func _on_tree_exited():
	print("exit1")
	#SaveSystem.save()


func _on_tree_exiting():
	print("exit2")


func _on_ui_start_game(newgame):
	start_game(newgame)


func _notification(what):
	print(what)
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveSystem.save()
