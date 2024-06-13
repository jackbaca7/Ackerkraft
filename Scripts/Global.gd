extends Node

var new_game = true

var workerprefix = "worker"
var worker_current_name = workerprefix + "1"

signal reload_worker_pannel()

var LAYERS = ["0", "1", "2", "3", "4"]

var GROUND : String = "1"
var BULDING : String = "0"
var PREVIEW : String = "2"
var WALL : String = "3"
var ROOF : String = "4"

const NONE = "-1"
const GROSS = 1
const ROAD_STRAIGHT_RIGHT = 2
const ROAD_X = 3
const STRAIGHT_TOP = 4
const ROAD_CORNER_RIGHT = 5
const ROAD_CORNER_TOP = 6
const ROAD_CORNER_LEFT = 7
const ROAD_CORNER_BOTTOM = 8
const ROAD_T_LEFT_TOP = 9
const ROAD_T_RIGHT_BOTTOM = 10
const ROAD_T_LEFT_BOTTOM = 11
const ROAD_T_RIGHT_TOP = 12

const BLACKSMITH : String = "13" 
const STONE : String = "Stone"

const FARM : String = "21" # food Potato
const POTATO : String = "Potato"

const WOOD_HOUSE : String = "18" # wood
const WOOD : String = "WOOD"

const CHURCH : String = "14" # sleep
const TABERN : String = "15" # fun
const MILL : String = "19" # speed 
const MARKET : String = "20" # Social

const TOWER : String = "16" # liberay weiterbilden Skills

const WATER_WELL : String = "17" # cave materials # Idee new map new cave








const task_speed_tile = {
	BLACKSMITH: 2.0, 
	CHURCH: 2.0, # sleep
	TABERN: 2.0, # fun
	TOWER: 2.0, # library weiterbilden
	WATER_WELL: 2.0, # cave materials # Idea new map new cave
	WOOD_HOUSE: 2.0, # wood
	MILL: 2.0, # speed 
	MARKET: 2.0, # Social
	FARM: 2.0  # food apple
}

var current_bulding_tile : String = "-1"
var preview_active = false

const STANDING  = "standing"
const RUNNING  = "running"
const WORKING = "working"
const WALKING = "walking"


func handle_building(tile_task: String, worker_name: String):
	var actions = {
		BLACKSMITH: _handle_blacksmith,
		FARM: _handle_farm,
		WOOD_HOUSE: _handle_wood_house,
		
		CHURCH: _handle_church,
		TABERN: _handle_tabern,
		MILL: _handle_mill,
		MARKET: _handle_market,
		
		TOWER: _handle_tower,
		
		WATER_WELL: _handle_water_well,
	}

	if tile_task in actions:
		actions[tile_task].call(worker_name)  # Call the function associated with the building ID
		#print("Reload_worker_pannel emit_signal: ", emit_signal("reload_worker_pannel"))
	else:
		print("No action defined for this building ID. tile_task: ", tile_task)

# ------------------- ITEMS ------------------- 
func _handle_blacksmith(worker_name: String):
	SaveSystem.add_item(worker_name, STONE, 1)
	SaveSystem.save()
	print("inventory: ", SaveSystem.get_worker_data(worker_name)["inventory"])
	print("Handling blacksmith activities... worker_name: ", worker_name)


func _handle_farm(worker_name: String):
	SaveSystem.add_item(worker_name, POTATO, 1)
	SaveSystem.save()
	print("inventory: ", SaveSystem.get_worker_data(worker_name)["inventory"])
	print("Handling farm activities for worker", worker_name)


func _handle_wood_house(worker_name: String):
	SaveSystem.add_item(worker_name, WOOD, 1)
	SaveSystem.save()
	print("inventory: ", SaveSystem.get_worker_data(worker_name)["inventory"])
	print("Handling wood house activities for worker", worker_name)

# ------------------- NEEDS -------------------  
func _handle_church(worker_name: String):
	print("Handling church activities for worker", worker_name)


func _handle_tabern(worker_name: String):
	print("Handling tabern activities for worker", worker_name)


func _handle_mill(worker_name: String):
	print("Handling mill activities for worker", worker_name)


func _handle_market(worker_name: String):
	print("Handling market activities for worker", worker_name)

# ------------------- Skills ------------------- 
func _handle_tower(worker_name: String):
	print("Handling tower activities for worker", worker_name)


func _handle_water_well(worker_name: String):
	print("Handling water well activities for worker", worker_name)


func _on_ui_select_worker(worker_id):
	print("UI_on_select_workerinsc")


func set_worker_name(index):
	print("set_worker_name: ", index)
	worker_current_name = workerprefix + str(index)


func set_bulding_tile(tile):
	current_bulding_tile = tile


func flip_preview_active():
	preview_active != preview_active


