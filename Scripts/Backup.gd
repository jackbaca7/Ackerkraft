"""



		if event.is_action_released("testing"):
			if polygon_stats_button.visible:
				polygon_stats_button.hide()
				print("hide")
			
			if polygon_stats_pannel.visible:
				polygon_stats_pannel.hide()
			
			if polygon_messages_pannel.visible:
				polygon_messages_pannel.hide()
				
		if event.is_action_released("testing2"):
			if !polygon_stats_button.visible:
				polygon_stats_button.show()
				print("show")
			
			if !polygon_stats_pannel.visible:
				polygon_stats_pannel.show()
			
			if !polygon_messages_pannel.visible:
				polygon_messages_pannel.show()



if !(check_click_within_bounds(stats_button   , polygon_stats_button) or
	check_click_within_bounds(stats_pannel   , polygon_stats_pannel) or 
	check_click_within_bounds(messages_pannel, polygon_messages_pannel)):

func minv(curvec,newvec):
	return Vector2(min(curvec.x,newvec.x),min(curvec.y,newvec.y))


func maxv(curvec,newvec):
	return Vector2(max(curvec.x,newvec.x),max(curvec.y,newvec.y))
	
func check_click_within_bounds(ui_element, polygon_element):
	if ui_element.visible:
		
		var min_vec = Vector2(MAX_COORD,MAX_COORD)
		var max_vec = Vector2(MIN_COORD,MIN_COORD)
		for v in polygon_element.polygon:
			min_vec = minv(min_vec,v)
			max_vec = maxv(max_vec,v)
		box = Rect2(min_vec,max_vec-min_vec)
		
		var mouse_pos = get_global_mouse_position()

		if mouse_pos.x >= element_pos.x and mouse_pos.x <= element_pos.x + element_size.x and mouse_pos.y >= element_pos.y and mouse_pos.y <= element_pos.y + element_size.y:
			print("Klick auf sichtbares", ui_element.name)
		else:
			print("Klick außerhalb von", ui_element.name)
	else:
		print(ui_element.name, "ist nicht sichtbar, kein Klick registriert")



"""
