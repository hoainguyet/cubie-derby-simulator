@tool
class_name MapCell extends Node2D



@export_range(1, 4) var type: int = 0 :
	set (value):
		type = value
		if get_node_or_null("Sprite2D") != null:
			$Sprite2D.texture = ResourceLoader.load("res://Assets/cell_" + str(type) + ".png")



