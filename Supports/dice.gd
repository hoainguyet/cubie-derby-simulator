@tool
extends Node2D



@export var dice_value: int = 1 :
	set (value):
		dice_value = value
		if get_node_or_null("Label") != null:
			$Label.text = str(value)



@export var active: bool = true :
	set (value):
		active = value
		if get_node_or_null("Sprite2D") != null:
			var modulate_value: float = 1.0 if active else 0.667
			$Sprite2D.modulate.a = modulate_value
			$Label.modulate.a = modulate_value


