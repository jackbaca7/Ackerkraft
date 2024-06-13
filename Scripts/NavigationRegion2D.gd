extends NavigationRegion2D

@onready var tile_map : TileMap = %TileMap
@export var tile_map_size : Dictionary = {}
var tile_map_ground_tiles = []

var last_preview_pos = Vector2i()

@onready var bulding_select_control = get_node("/root/Game/UI/Control/bulding_select_control")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global.new_game:
		tile_map_size = {
			"max_x": 10,
			"min_x": -10,
			"max_y": 10,
			"min_y": -10
		}
		# setup tilemap and setup Navigation Region
		for x in range(tile_map_size["min_x"], tile_map_size["max_x"]):
			for y in range(tile_map_size["min_y"], tile_map_size["max_y"]):
				var vector = Vector2i(x, y)
				tile_map.set_cell(int(Global.GROUND), vector, Global.GROSS, Vector2i(0,0))
				SaveSystem.add_tile_data(Global.GROUND, vector, {"tile": Global.GROSS, "position": {"x" : x, "y" : y}})
				
		tile_map.set_cell(int(Global.BULDING), Vector2i(3, 3), int(Global.BLACKSMITH), Vector2i(0,0))
		SaveSystem.add_tile_data(Global.BULDING, Vector2i(3, 3), {"tile": Global.BLACKSMITH, "duration": Global.task_speed_tile[Global.BLACKSMITH], "position": {"x" : 3, "y" : 3}})
		
		tile_map.set_cell(int(Global.BULDING), Vector2i(-2, -3), int(Global.BLACKSMITH), Vector2i(0,0))
		SaveSystem.add_tile_data(Global.BULDING, Vector2i(-2, -3), {"tile": Global.BLACKSMITH, "duration": Global.task_speed_tile[Global.BLACKSMITH],  "position": {"x" : -2, "y" : -3}})
		
		tile_map.set_cell(int(Global.BULDING), Vector2i(2, 1), int(Global.BLACKSMITH), Vector2i(0,0))
		SaveSystem.add_tile_data(Global.BULDING, Vector2i(2, 1), {"tile": Global.BLACKSMITH, "duration": Global.task_speed_tile[Global.BLACKSMITH], "position": {"x" : 2, "y" : 1}})
		
		tile_map.set_cell(int(Global.BULDING), Vector2i(1, 2), int(Global.BLACKSMITH), Vector2i(0,0))
		SaveSystem.add_tile_data(Global.BULDING, Vector2i(1, 2), {"tile": Global.BLACKSMITH, "duration": Global.task_speed_tile[Global.BLACKSMITH], "position": {"x" : 1, "y" : 2}})
		
		tile_map.set_cell(int(Global.BULDING), Vector2i(3, -4), int(Global.WATER_WELL), Vector2i(0,0))
		SaveSystem.add_tile_data(Global.BULDING, Vector2i(3, -4), {"tile": Global.BLACKSMITH, "duration": Global.task_speed_tile[Global.BLACKSMITH], "position": {"x" : 3, "y" : -4}})
		
		tile_map.set_cell(int(Global.BULDING), Vector2i(1, 2), int(Global.BLACKSMITH), Vector2i(0,0))
		SaveSystem.add_tile_data(Global.BULDING, Vector2i(1, 2), {"tile": Global.BLACKSMITH, "duration": Global.task_speed_tile[Global.BLACKSMITH], "position": {"x" : 1, "y" : 2}})
		SaveSystem.save()
	else:
		var list_tile_map = SaveSystem.get_tile_map()
		if list_tile_map != null:
			tile_map_size = get_tile_map_size(list_tile_map)
			# Iterate through each layer in the map
			for layer in list_tile_map.keys():
				# Iterate through each tile position within the layer
				for tile_position in list_tile_map[layer].keys():
					# Retrieve the tile data
					var tile_data = list_tile_map[layer][tile_position]
					# Print the layer, tile position, and tile data
					print("Layer:", layer, ", Tile Position:", tile_position, ", Data:", tile_data)
					
					var position_tile_vec = Vector2i(tile_data["position"]["x"], tile_data["position"]["y"])
					tile_map.set_cell(int(layer), position_tile_vec, int(tile_data["tile"]), Vector2i(0,0))
	
	var tile_map_tile_size_x = 1000
	var tile_map_tile_size_y = 610
	
	var endpoint_x_positiv = tile_map_size["max_x"] * tile_map_tile_size_x
	var endpoint_x_negativ = tile_map_size["min_x"] * tile_map_tile_size_x
	var endpoint_y_positiv = tile_map_size["max_y"] * tile_map_tile_size_y
	var endpoint_y_negativ = tile_map_size["min_y"] * tile_map_tile_size_y
	
	var new_navigation_mesh = NavigationPolygon.new()
	var bounding_outline = PackedVector2Array([Vector2(0, endpoint_y_positiv), Vector2(endpoint_x_positiv, 0), Vector2(0, endpoint_y_negativ), Vector2(endpoint_x_negativ, 0)])
	
	new_navigation_mesh.add_outline(bounding_outline)
	NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, NavigationMeshSourceGeometryData2D.new());
	navigation_polygon = new_navigation_mesh
	print("set NavigationRegion2D and tile_map")


func _input(event):
	if not is_ui_interaction(event):
		if event.is_action_pressed("preview_building"):
			Global.preview_active = !Global.preview_active
			if !Global.preview_active: 
				clear_preview()
		elif event.is_action_pressed("place_building"):
			if Global.preview_active:
				place_bulding()


func is_ui_interaction(event):
	# Check if the event is a mouse button event
	if event is InputEventMouseButton:
	# Get the global mouse position
		var global_mouse_pos = event.global_position
		# Check if the mouse is over the UI element
		if bulding_select_control.get_global_rect().has_point(global_mouse_pos):
			return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_tile = tile_map.local_to_map(get_global_mouse_position())
	if Global.preview_active and last_preview_pos != mouse_tile and Global.current_bulding_tile != "-1":
		tile_map.set_cell(int(Global.PREVIEW), last_preview_pos, -1)
		tile_map.set_cell(int(Global.PREVIEW), mouse_tile, int(Global.current_bulding_tile), Vector2i(0,0))
	last_preview_pos = mouse_tile


func get_tile_map_size(list_tile_map):
	var tile_position_x_max = float('-inf')  # Start with the lowest possible number
	var tile_position_y_max = float('-inf')  # Start with the lowest possible number
	var tile_position_x_min = float('inf')   # Start with the highest possible number
	var tile_position_y_min = float('inf')   # Start with the highest possible number

	for tile_position in list_tile_map[str(Global.GROUND)].keys():
		# Retrieve the tile data
		var tile_data = list_tile_map[str(Global.GROUND)][tile_position]
		var x = tile_data["position"]["x"]
		var y = tile_data["position"]["y"] 

		# Update max and min for x
		if x > tile_position_x_max:
			tile_position_x_max = x
		if x < tile_position_x_min:
			tile_position_x_min = x

		# Update max and min for y
		if y > tile_position_y_max:
			tile_position_y_max = y
		if y < tile_position_y_min:
			tile_position_y_min = y
	
	# Package the values into a dictionary
	var bounds = {
		"max_x": tile_position_x_max,
		"min_x": tile_position_x_min,
		"max_y": tile_position_y_max,
		"min_y": tile_position_y_min
	}
	return bounds


func check_place(bulding, tile):
	var cleartoplace = true
	for index in bulding.size():
		for layer in Global.LAYERS:
			var shift = bulding[index]["position"]
			var data = Global.get_tile_data(Vector2i(tile.x + shift.x, tile.y + shift.y), layer)
			if ((layer == Global.GROUND and data == null) or (layer != Global.GROUND and data)) and cleartoplace:
				cleartoplace = false
	print("cleartoplace: ", cleartoplace)
	return cleartoplace

func place_bulding():
	if Global.current_bulding_tile != "-1":
		tile_map.set_cell(int(Global.BULDING), last_preview_pos, int(Global.current_bulding_tile), Vector2i(0,0))
		#SaveSystem.add_tile_data(Global.BULDING, last_preview_pos, {"tile": Global.BLACKSMITH, "position": {"x" : last_preview_pos.x, "y" : last_preview_pos.y}})
		SaveSystem.add_tile_data(Global.BULDING, last_preview_pos, 
			{"tile": Global.current_bulding_tile, "position": {"x" : last_preview_pos.x, "y" : last_preview_pos.y}})
		SaveSystem.save()

func clear_preview():
	tile_map.clear_layer(int(Global.PREVIEW))
	

