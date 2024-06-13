extends Camera2D

@export var zoomval = 0.2


"""
@export var target: Node = null:[
	set(tar):
		fallback_target = tar if fall 
]"""

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = Vector2(zoomval, zoomval)

func _on_property_list_changed():
	zoom = Vector2(zoomval, zoomval)
