extends CharacterBody2D

signal reload_worker_panel


@onready var stats_button = get_node("/root/Game/UI/Control/worker_stats_view/worker_stats_button")
@onready var stats_pannel = get_node("/root/Game/UI/Control/worker_stats_view/worker_stats_panel")
@onready var messages_pannel = get_node("/root/Game/UI/Control/worker_stats_view/messages_panel")
"""
@onready var polygon_stats_button = get_node("/root/Game/UI/Control/worker_stats_view/polygon_stats_button")
@onready var polygon_stats_pannel : Polygon2D = get_node("/root/Game/UI/Control/worker_stats_view/polygon_stats_pannel")
@onready var polygon_messages_pannel = get_node("/root/Game/UI/Control/worker_stats_view/polygon_message")
"""
const MAX_COORD = pow(2,31)-1
const MIN_COORD = -MAX_COORD
var box # your polygon bounding box (Rect2)

@onready var directiong = Vector2.ZERO

@onready var tilemap = $"../TileMap"
var curremt_path: Array[Vector2i]

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

@onready var working_timer : Timer = $working_timer

@export var speed = 600
@export var acceleration = 100

@onready var tile_map : TileMap

@export var worker_skill_speed = 1
var worker_status = Global.STANDING
var task = Global.NONE
var taskspeed = 1

@export var multi = 1


func _ready():
	animation_tree.active = true
	animation_player.stop()
	
	var worker = SaveSystem.get_worker_data(name)
	var worker_skills = worker["skills"]
	if "skills" in worker:
		if "Speed" in worker["skills"]:
			worker_skill_speed = worker["skills"]["Speed"]["level"]
	

func _physics_process(delta):
	"""if name == "worker1":
		print(name, "timer: ", working_timer.get_wait_time(), " - worker_status:", worker_status, 
		" - taskspeed: ", taskspeed, " - multi: ", multi, " - task: ", task)"""

#set_wait_time

func _process(delta):
	
	if curremt_path.is_empty():
		return
	
	var target_position = tilemap.map_to_local(curremt_path.front())
	var direction = (target_position - global_position).normalized()
	global_position = global_position.move_toward(target_position, 2 * (speed / 100))
	
	if global_position == target_position:
		curremt_path.pop_front()
		if curremt_path.is_empty():
			worker_status = Global.WORKING
			SaveSystem.set_status(name, Global.WORKING)
			animation_state.travel("Idle")
			animation_tree.set("parameters/Idle/blend_position", velocity) #velocity

			working_timer.start(taskspeed)
		else:
			worker_status = Global.WORKING
			SaveSystem.set_status(name, Global.RUNNING)
			animation_tree.set("parameters/Running/blend_position", direction)
			
			working_timer.stop() 
	else:
		SaveSystem.set_status(name, Global.RUNNING)
		animation_tree.set("parameters/Running/blend_position", direction)
		animation_state.travel("Running")
		
		working_timer.stop()


func _input(event):
	if name == Global.worker_current_name and !Global.preview_active:
		if event is InputEventMouseButton: 
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var tile_data = check_tile_building(tilemap.local_to_map(get_global_mouse_position()))
				if tile_data:
					tile_map = get_node("/root/Game/TileMap")
					if tile_map:
						task = tile_data["tile"] 
						multi = (worker_skill_speed / 10)
						taskspeed = tile_data["duration"] * multi
						
						worker_status = Global.WORKING
						SaveSystem.set_task(name, task, taskspeed)
						print(multi)
						
						curremt_path = tilemap.astar.get_id_path(
							tilemap.local_to_map(global_position),
							tilemap.local_to_map(get_global_mouse_position())
						)
						
						print("curremt_path", curremt_path)
				else:
					print("no tile data")
					

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idel"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		#animation_tree["parameters/conditions/is_working"] = true
	else:
		animation_tree["parameters/conditions/idel"] = false
		animation_tree["parameters/conditions/is_moving"] = true


func check_tile_building(tile):
	var data = SaveSystem.get_tile_data(Vector2i(tile.x, tile.y), Global.BULDING)
	if data: 
		return data
	else:
		null


func _on_working_timer_timeout():
	if Global.WORKING == worker_status:
		#tileindex(Task) to item to add or the finsh task 
		Global.handle_building(task, name)
		print("Reload_worker_pannel emit_signal: ", emit_signal("reload_worker_panel"))


func _on_health_timer_timeout():
	SaveSystem.handle_health(name, 1.0)
	print("Reload_worker_pannel emit_signal: ", emit_signal("reload_worker_panel"))
