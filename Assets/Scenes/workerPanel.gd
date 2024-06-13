extends Panel

signal reload_worker_panel()


@onready var messages_label = %messages_label

@onready var worker_stats_panel = %worker_stats_panel

@onready var worker_scroll_container : ScrollContainer = %worker_scroll_container 
@onready var worker_scroll_control = %worker_scroll_control
@export var worker_scroll_control_x_min_size = 238
@export var worker_scroll_control_row_size = 23

@onready var worker_stats_label = %worker_panel_label

@onready var worker_quests = %worker_quests
@onready var worker_inventory = %worker_inventory
@onready var worker_skills = %woker_skills
@onready var worker_health = %worker_health

@onready var current_stats


@onready var quest_container1 = %quest_container1
@onready var quest_label1 = %quest_label1
@onready var points_label1 = %points_label1

@onready var quest_container2 = %quest_container2
@onready var quest_label2 = %quest_label2
@onready var points_label2 = %points_label2

@onready var quest_container3 = %quest_container3
@onready var quest_label3 = %quest_label3
@onready var points_label3 = %points_label3


@onready var inventory_container1 = %inventory_container1
@onready var inventory_container2 = %inventory_container2
@onready var inventory_container3 = %inventory_container3
@onready var inventory_container4 = %inventory_container4

@onready var skillcontainer1 = %woker_skills/%skill_container1
@onready var skillcontainer2 = %woker_skills/%skill_container2
@onready var skillcontainer3 = %woker_skills/%skill_container3
@onready var skillcontainer4 = %woker_skills/%skill_container4
@onready var skillcontainer5 = %woker_skills/%skill_container5
@onready var skillcontainer6 = %woker_skills/%skill_container6
@onready var skillcontainer7 = %woker_skills/%skill_container7
@onready var skillcontainer8 = %woker_skills/%skill_container8
@onready var skillcontainer9 = %woker_skills/%skill_container9
@onready var skillcontainer10 = %woker_skills/%skill_container10

@onready var hunger_progress_bar = %worker_health/%hunger_progress_bar
@onready var sleep_progress_bar = %worker_health/%sleep_progress_bar
@onready var fun_progress_bar = %worker_health/%fun_progress_bar
@onready var social_progress_bar = %worker_health/%social_progress_bar

func _input(event):
	if event.is_action_pressed("select_worker_one"):
		Global.set_worker_name(1)
		print("select_worker_one")
		change_worker_panel(current_stats, "")
	if event.is_action_pressed("select_worker_two"):
		Global.set_worker_name(2)
		print("select_worker_two")
		change_worker_panel(current_stats, "")

func _on_aspirations_button_pressed():
	print("_on_quest_button_pressed")
	change_worker_panel(worker_quests, "quests", true)


func _on_traits_button_pressed():
	print("_on_traits_button_pressed")
	change_worker_panel(worker_health, "quests", true)


func _on_inventory_button_pressed():
	print("_on_inventory_button_pressed")
	change_worker_panel(worker_inventory, "inventory", true)


func _on_skills_button_pressed():
	print("_on_skills_button_pressed")
	change_worker_panel(worker_skills, "skills", true)


func _on_needs_button_pressed():
	print("_on_needs_button_pressed")
	change_worker_panel(worker_health, "needs", true)


func change_worker_panel(worker_panel_select = current_stats, titel = "", toggel_visibility = false):
	if toggel_visibility:
		if worker_stats_panel.visible and current_stats == worker_panel_select:
			worker_stats_panel.hide()
			return
		else:
			worker_stats_panel.show()
	
	if current_stats:
		current_stats.hide()
	if titel.length() != 0:
		worker_stats_label.text = titel
	set_worker_panel(worker_panel_select)
	
	current_stats = worker_panel_select

func set_worker_panel(panel):
	# Get the worker data
	var worker_data = SaveSystem.get_worker_data(Global.worker_current_name)
	print(worker_data)
	if worker_data:
		if panel == worker_quests:
			# Set labels for goals
			print("Setting goals panel")
			if worker_data["goals"] != null:
				var goal_keys = worker_data["goals"].keys()
				var containers = [quest_container1, quest_container2, quest_container3]
				for i in range(len(containers)):
					var container = containers[i]
					if i < goal_keys.size():
						var goal_name = goal_keys[i]
						var goal_value = worker_data["goals"][goal_name]
						if !container.visible:
							container.show()
						container.get_child(0).text = goal_name
						container.get_child(1).text = str(goal_value) + " xp"
					else:
						container.hide()
				worker_quests.show()
			else:
				print("worker_data[goals] is null")

		elif panel == worker_inventory:
			# Set labels for inventory
			if worker_data["inventory"] != null:
				print("Setting inventory panel")
				var inventory_keys = worker_data["inventory"].keys()

				# Lösche alle vorhandenen Nodes in worker_inventory
				if current_stats:
					clear_node_children(panel)

				# Lade die inventory_row.tscn Szene
				var inventory_row_scene = load("res://Assets/Scenes/inventory_row.tscn")

				for item_name in inventory_keys:
					var item_amount = worker_data["inventory"][item_name]
					var inventory_row_instance = inventory_row_scene.instantiate()

					# Setze die Item-Daten in die Labels der inventory_row.tscn-Instanz
					inventory_row_instance.get_node("Item_Label").text = item_name
					inventory_row_instance.get_node("Amount_Label").text = str(item_amount)

					# Füge die Instanz zu worker_inventory hinzu
					worker_inventory.add_child(inventory_row_instance)
				
				worker_inventory.show()
			else:
				print("worker_data[inventory] is null")

		elif panel == worker_skills:
			# Set labels for skills
			if worker_data["skills"] != null:
				print("Setting skills panel")
				var inventory_keys = worker_data["skills"].keys()

				# Lösche alle vorhandenen Nodes in worker_inventory
				clear_node_children(panel)

				# Lade die inventory_row.tscn Szene
				var inventory_row_scene = load("res://Assets/Scenes/skill_row.tscn")

				for item_name in inventory_keys:
					var progress = worker_data["skills"][item_name]["progress"]
					var level = str(worker_data["skills"][item_name]["level"])
					var skill_row_instance = inventory_row_scene.instantiate()

					# Setze die Item-Daten in die Labels der inventory_row.tscn-Instanz
					skill_row_instance.get_node("skill_label").text = item_name
					skill_row_instance.get_node("skill_progress_bar").value = progress
					skill_row_instance.get_node("level_label").text = str(level)

					# Füge die Instanz zu worker_inventory hinzu
					worker_skills.add_child(skill_row_instance)
				
				worker_skills.show()
			else:
				print("worker_data[skills] is null")

		elif panel == worker_health:
			# Set labels for health
			if worker_data["health"] != null:
				print("Setting health panel")
				hunger_progress_bar.value = worker_data["health"]["Hunger"]
				sleep_progress_bar.value = worker_data["health"]["Sleep"]
				fun_progress_bar.value = worker_data["health"]["Fun"]
				social_progress_bar.value = worker_data["health"]["Social"]
				worker_health.show()
			else:
				print("worker_data[health] is null")


# Funktion zum Löschen aller Kinder eines Nodes
func clear_node_children(parent_node):
	for child in parent_node.get_children():
		parent_node.remove_child(child)
		child.queue_free()


func _on_reload_worker_panel():
	change_worker_panel()


func _on_worker_reload_worker_panel():
	print("_on_worker_reload_worker_pannel!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")


func _on_ui_change_worker():
	print("_on_ui_change_worker")
	change_worker_panel()
