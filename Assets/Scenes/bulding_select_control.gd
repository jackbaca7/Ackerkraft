extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_farm_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.FARM)
	print("_on_tower_button_pressed TOWER ", Global.FARM)


func _on_church_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.CHURCH)
	print("_on_tower_button_pressed TOWER ", Global.CHURCH)


func _on_tabern_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.TABERN)
	print("_on_tower_button_pressed TOWER ", Global.TABERN)


func _on_market_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.MARKET)
	print("_on_tower_button_pressed TOWER ", Global.MARKET)


func _on_mill_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.MILL)
	print("_on_tower_button_pressed TOWER ", Global.MILL)


func _on_tower_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.TOWER)
	print("_on_tower_button_pressed TOWER ", Global.TOWER)


func _on_wood_house_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.WOOD_HOUSE)
	print("_on_tower_button_pressed TOWER ", Global.WOOD_HOUSE)


func _on_water_well_button_toggled(toggled_on):
	Global.set_bulding_tile(Global.WATER_WELL)
	print("_on_tower_button_pressed TOWER ", Global.WATER_WELL)



func _on_farm_button_pressed():
	Global.set_bulding_tile(Global.FARM)
	print("_on_tower_button_pressed TOWER ", Global.FARM)


func _on_church_button_pressed():
	Global.set_bulding_tile(Global.CHURCH)
	print("_on_tower_button_pressed TOWER ", Global.CHURCH)


func _on_tabern_button_pressed():
	Global.set_bulding_tile(Global.TABERN)
	print("_on_tower_button_pressed TOWER ", Global.TABERN)


func _on_market_button_pressed():
	Global.set_bulding_tile(Global.MARKET)
	print("_on_tower_button_pressed TOWER ", Global.MARKET)


func _on_mill_button_pressed():
	Global.set_bulding_tile(Global.MILL)
	print("_on_tower_button_pressed TOWER ", Global.MILL)


func _on_tower_button_pressed():
	Global.set_bulding_tile(Global.TOWER)
	print("_on_tower_button_pressed TOWER ", Global.TOWER)


func _on_wood_house_button_pressed():
	Global.set_bulding_tile(Global.WOOD_HOUSE)
	print("_on_tower_button_pressed TOWER ", Global.WOOD_HOUSE)


func _on_water_well_button_pressed():
	Global.set_bulding_tile(Global.WATER_WELL)
	print("_on_tower_button_pressed TOWER ", Global.WATER_WELL)
