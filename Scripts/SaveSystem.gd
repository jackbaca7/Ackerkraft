extends Node

# Path where the save file will be stored.
var tile_map_path := "user://tilemap.json"
var worker_path := "user://worker.json"
var settings_path := "user://settings.json"
var File = FileAccess

@onready var List_tile_map = {}

@onready var List_worker

@onready var List_setting

func _ready():
	print("SaveSystem_ready")
	List_tile_map = {}
	List_worker = {}
	List_setting = {}


func save():
	var file_tile_map = File.open(tile_map_path, FileAccess.WRITE)
	var save_data_tile_map = JSON.stringify(List_tile_map, "\t")
	file_tile_map.store_string(save_data_tile_map)
	
	var file_worker = File.open(worker_path, FileAccess.WRITE)
	var save_data_worker = JSON.stringify(List_worker)
	file_worker.store_string(save_data_worker)
	
	var file_setting = File.open(settings_path, FileAccess.WRITE)
	var save_data_setting = JSON.stringify(List_setting)
	file_setting.store_string(save_data_setting)
	
	file_tile_map.close()
	file_worker.close()
	file_setting.close()
	#print(List_tilew_map)
	
func load():
	var file_tile_map = File.open(tile_map_path, FileAccess.READ)
	var tile_map_json_object = JSON.new()
	var tile_map_parse_err = tile_map_json_object.parse(file_tile_map.get_as_text())
	var paresdResult = tile_map_json_object.parse_string(file_tile_map.get_as_text())
	if !tile_map_parse_err and paresdResult is Dictionary:
		List_tile_map = paresdResult
	
	#print(List_tile_map)
	var file_worker = File.open(worker_path, FileAccess.READ)
	var worker_json_object = JSON.new()
	var worker_parse_err = worker_json_object.parse(file_worker.get_as_text())
	List_worker = worker_json_object.get_data()
	
	var file_setting = File.open(settings_path, FileAccess.READ)
	var settings_json_object = JSON.new()
	var settings_parse_err = settings_json_object.parse(file_setting.get_as_text())
	List_setting = settings_json_object.get_data()
	
	file_tile_map.close()
	file_worker.close()
	file_setting.close()
	print("load")


func clearfiles():
	var file_tile_map = File.open(tile_map_path, FileAccess.WRITE)
	file_tile_map = "{}"
	
	var file_worker = File.open(worker_path, FileAccess.WRITE)
	file_worker = "{}"

func set_file_worker():
	add_worker_data("worker1", {
		"activity": {
			"status": Global.STANDING,
			"task":  Global.NONE,
			"taskspeed" : 1
		},
		"goals": {
			"Master a Specific Craft": 150,
			"Discover Rare Resources": 200,
			"Create a Masterpiece": 50,
			"Maximize Your Speed": 100,
			"Explore Unknown Territories": 5000
		},
		"inventory": {
			"Wood": 10,
			"Potato": 5,
			"Meet": 20,
			"Fisch": 100,
			"Metal": 2 
		},
		"skills": {
			"Efficient Harvesting": {"progress": 99, "level": 10},
			"Speed": {"progress": 70, "level": 4},
			"Animal Care": {"progress": 50, "level": 3},
			"Breeding": {"progress": 20, "level": 2},
			"Building": {"progress": 10, "level": 1},
			"Efficient Construction": {"progress": 20, "level": 2},
			"Exploration": {"progress": 10, "level": 10},
			"Cartography": {"progress": 60, "level": 5},
			"Survival Skills": {"progress": 0, "level": 3}
		},
		"health": {
			"Hunger": 100.0,
			"Sleep": 50.0,
			"Fun": 10.0,
			"Social": 45.0
		}
	})

	add_worker_data("worker2", {
		"activity": {
			"status": Global.STANDING,
			"task":  Global.NONE,
			"taskspeed" : 1
		},
		"goals": {
			"Establish a New Colony": 300,
			"Achieve Sustainable Farming": 250,
			"Negotiate Trade Agreements": 150,
			"Innovate Technology": 200,
			"Map New Lands": 4000
		},
		"inventory": {
			"Wood": 10,
			"Potato": 5,
			"Meet": 20,
			"Fisch": 100,
			"Metal": 2 
		},
		"skills": {
			"Efficient Farming": {"progress": 80, "level": 5},
			"Negotiation": {"progress": 40, "level": 2},
			"Technology Development": {"progress": 30, "level": 1},
			"Construction": {"progress": 25, "level": 3},
			"Cartography": {"progress": 90, "level": 7},
			"Exploration": {"progress": 50, "level": 4},
			"Survival Skills": {"progress": 20, "level": 2},
			"Herbalism": {"progress": 75, "level": 6},
			"Speed": {"progress": 5, "level": 2}
		},
		"health": {
			"Hunger": 90.0,
			"Sleep": 70.0,
			"Fun": 20.0,
			"Social": 60.0
		}
	})

	
	SaveSystem.save()


# Function to add tile data
func add_tile_data(layer, tile_position, tile_data):
	print("add_tile_data( ", tile_position)
	
	# Ensure the layer exists in the map; if not, initialize it as a new dictionary
	if List_tile_map == null:
		List_tile_map = {}
	
	if not List_tile_map.has(layer):
		List_tile_map[layer] = {}
	# Stores the tile data under the generated key
	List_tile_map[layer][tile_position] = tile_data


# Function to retrieve tile data
func get_tile_data(tile_position, layer):
	if List_tile_map == null:
		List_tile_map = {}
	
	if layer in List_tile_map:
		if tile_position in List_tile_map[layer]:
			return List_tile_map[layer][tile_position]
	return null


# Function to add tile data
func add_worker_data(worker_name, worker_data):
	# Ensure the layer exists in the map; if not, initialize it as a new dictionary
	if List_worker == null:
		List_worker = {}
	
	# Stores the tile data under the generated key
	List_worker[worker_name] = worker_data

func add_item(worker_name, item_name, amount_to_add):
	if List_worker == null:
		List_worker = {}

	if item_name in List_worker[worker_name]["inventory"]:
		List_worker[worker_name]["inventory"][item_name] += amount_to_add
	else:
		List_worker[worker_name]["inventory"][item_name] = amount_to_add


# Function to retrieve worker data
func get_worker_data(worker_name):
	if worker_name in List_worker:
		return List_worker[worker_name]
	return null

func get_tile_map():
	return List_tile_map


func get_workers():
	return List_worker


func get_settings():
	return List_setting

func set_status(worker_name, status):
	if List_worker == null:
		List_worker = {}
	
	if List_worker[worker_name]["activity"]:
		List_worker[worker_name]["activity"]["status"] = status


func set_task(worker_name, task, taskspeed):
	if List_worker == null:
		List_worker = {}
	
	if List_worker[worker_name]["activity"]:
		List_worker[worker_name]["activity"]["task"] = task
		List_worker[worker_name]["activity"]["taskspeed"] = taskspeed
		


func handle_health(worker_name, health_decrease):
	# subtract health values	
	if List_worker == null:
		List_worker = {}

	if List_worker[worker_name]["activity"]["status"] != Global.WORKING:
		return
	
	if List_worker[worker_name]["health"]:
		for health_key in List_worker[worker_name]["health"]:
			List_worker[worker_name]["health"][health_key] -= health_decrease
